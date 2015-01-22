require 'dotenv'

begin
  require 'spring/watcher'
rescue LoadError
  # Spring is not available
end

module Dotenv
  class Railtie < Rails::Railtie
    config.before_configuration { load }

    # Public: Load dotenv
    #
    # This will get called during the `before_configuration` callback, but you
    # can manually call `Dotenv::Railtie.load` if you needed it sooner.
    def load
      Dotenv.instrumenter = ActiveSupport::Notifications
      configure_spring if defined?(Spring)

      Dotenv.load root.join('.env')
    end

    # Internal: Watch all loaded env files with spring
    def configure_spring
      ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        Spring.watch event.payload[:env].filename
      end
    end

    # Internal: `Rails.root` is nil in Rails 4.1 before the application is
    # initialized, so this falls back to the `RAILS_ROOT` environment variable,
    # or the current workding directory.
    def root
      Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end
  end
end
