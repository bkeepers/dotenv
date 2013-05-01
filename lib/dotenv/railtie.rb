require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie

    # Load .env immediately
    Dotenv.load ".env.#{Rails.env}", '.env'

    # Expose all the environment variables in config.env
    config.env = Dotenv.config

    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env'
      end
    end

  end
end

