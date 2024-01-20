require "dotenv"

# Watch all loaded env files with Spring
begin
  require "spring/commands"
  ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError, ArgumentError
  # Spring is not available
end

module Dotenv
  # Rails integration for using Dotenv to load ENV variables from a file
  class Rails < ::Rails::Railtie
    attr_accessor :mode, :files

    def initialize
      @mode = :load
      @files = [
        root.join(".env.#{env}.local"),
        (root.join(".env.local") unless env.test?),
        root.join(".env.#{env}"),
        root.join(".env")
      ].compact
    end

    # Public: Load dotenv
    #
    # This will get called during the `before_configuration` callback, but you
    # can manually call `Dotenv::Railtie.load` if you needed it sooner.
    def load
      Dotenv.load(*files)
    end

    # Public: Reload dotenv
    #
    # Same as `load`, but will override existing values in `ENV`
    def overload
      Dotenv.overload(*files)
    end

    # Internal: `Rails.root` is nil in Rails 4.1 before the application is
    # initialized, so this falls back to the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def root
      ::Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    def env
      env = ::Rails.env

      # Dotenv loads environment variables when the Rails application is initialized.
      # When running `rake`, the Rails application is initialized in development.
      # Rails includes some hacks to set `RAILS_ENV=test` when running `rake test`,
      # but rspec does not include the same hacks.
      #
      # See https://github.com/bkeepers/dotenv/issues/219
      if defined?(Rake.application)
        task_regular_expression = /^(default$|parallel:spec|spec(:|$))/
        if Rake.application.top_level_tasks.grep(task_regular_expression).any?
          env = ActiveSupport::EnvironmentInquirer.new(Rake.application.options.show_tasks ? "development" : "test")
        end
      end

      env
    end

    def deprecator # :nodoc:
      @deprecator ||= ActiveSupport::Deprecation.new
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end

    initializer "dotenv.deprecator" do |app|
      app.deprecators[:dotenv] = deprecator
    end

    config.before_configuration do
      Dotenv.instrumenter = ActiveSupport::Notifications
      mode == :load ? load : overload
    end
  end

  Railtie = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Dotenv::Railtie", "Dotenv::Rails", Dotenv::Rails.deprecator)
end
