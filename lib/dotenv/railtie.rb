require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    config.before_configuration do
      Dotenv.load Rails.root.join('.env')
      Spring.watch Rails.root.join('.env') if defined?(Spring)
    end
  end
end
