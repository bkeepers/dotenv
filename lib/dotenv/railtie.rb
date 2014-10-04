require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    config.before_configuration do
      Dotenv.load Rails.root.join('.env')

      begin
        require "spring/watcher"
        Spring.watch Rails.root.join('.env')
      rescue LoadError
      end
    end
  end
end
