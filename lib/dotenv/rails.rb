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

      Dotenv.load Rails.root.join('.env')
    end

    # Internal: subscribe to
    def configure_spring
      @spring_subscriber = ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        Spring.watch event.payload[:env].filename
      end
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end
  end
end
