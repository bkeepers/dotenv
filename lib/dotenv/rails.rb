require "dotenv"
require "dotenv/replay_logger"
require "dotenv/log_subscriber"

Dotenv.instrumenter = ActiveSupport::Notifications

# Watch all loaded env files with Spring
begin
  require "spring/commands"
  ActiveSupport::Notifications.subscribe("load.dotenv") do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError, ArgumentError
  # Spring is not available
end

module Dotenv
  # Rails integration for using Dotenv to load ENV variables from a file
  class Rails < ::Rails::Railtie
    delegate :files, :files=, :overwrite, :overwrite=, :autorestore, :autorestore=, :logger, :logger=, to: "config.dotenv"

    def initialize
      super()
      config.dotenv = ActiveSupport::OrderedOptions.new.update(
        # Rails.logger is not available yet, so we'll save log messages and replay them when it is
        logger: Dotenv::ReplayLogger.new,
        overwrite: false,
        files: [
          root.join(".env.#{env}.local"),
          (root.join(".env.local") unless env.test?),
          root.join(".env.#{env}"),
          root.join(".env")
        ].compact,
        autorestore: env.test?
      )
    end

    # Public: Load dotenv
    #
    # This will get called during the `before_configuration` callback, but you
    # can manually call `Dotenv::Rails.load` if you needed it sooner.
    def load
      Dotenv.load(*files, overwrite: overwrite)
    end

    def overload
      deprecator.warn("Dotenv::Rails.overload is deprecated. Set `Dotenv::Rails.overwrite = true` and call Dotenv::Rails.load instead.")
      Dotenv.load(*files, overwrite: true)
    end

    # Internal: `Rails.root` is nil in Rails 4.1 before the application is
    # initialized, so this falls back to the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def root
      ::Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    # The current environment that the app is running in.
    #
    # When running `rake`, the Rails application is initialized in development, so we have to
    # check which rake tasks are being run to determine the environment.
    #
    # See https://github.com/bkeepers/dotenv/issues/219
    def env
      @env ||= if defined?(Rake.application) && Rake.application.top_level_tasks.grep(TEST_RAKE_TASKS).any?
        env = Rake.application.options.show_tasks ? "development" : "test"
        ActiveSupport::EnvironmentInquirer.new(env)
      else
        ::Rails.env
      end
    end
    TEST_RAKE_TASKS = /^(default$|test(:|$)|parallel:spec|spec(:|$))/

    def deprecator # :nodoc:
      @deprecator ||= ActiveSupport::Deprecation.new
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end

    initializer "dotenv", after: :initialize_logger do |app|
      # Set up a new logger once Rails has initialized the logger and replay logs
      new_logger = ActiveSupport::TaggedLogging.new(::Rails.logger).tagged("dotenv")
      logger.replay new_logger if logger.respond_to?(:replay)
      self.logger = new_logger
    end

    initializer "dotenv.deprecator" do |app|
      app.deprecators[:dotenv] = deprecator if app.respond_to?(:deprecators)
    end

    initializer "dotenv.autorestore" do |app|
      require "dotenv/autorestore" if autorestore
    end

    config.before_configuration { load }
  end

  Railtie = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Dotenv::Railtie", "Dotenv::Rails", Dotenv::Rails.deprecator)
end
