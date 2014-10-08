require 'dotenv'
begin
  require 'spring/watcher'
rescue LoadError
  # Spring is not available
end

module Dotenv
  class Railtie < Rails::Railtie
    config.before_configuration { load }

    def load
      Dotenv.load Rails.root.join('.env')
      Spring.watch Rails.root.join('.env') if defined?(Spring)
    end
  end
end
