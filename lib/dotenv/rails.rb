require 'dotenv'

Dotenv.instrumenter = ActiveSupport::Notifications

begin
  require 'spring/watcher'

  ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename
  end
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
      Dotenv.load Rails.root.join('.env')
      Spring.watch Rails.root.join('.env') if defined?(Spring)
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end
  end
end
