require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    module Env
      extend ActiveSupport::Concern

      included do
        helper_method :env
      end

      def env
        Dotenv.config
      end
    end

    # Load .env immediately
    Dotenv.load ".env.#{Rails.env}", '.env'

    # Expose all the environment variables in config.env
    config.env = Dotenv.config

    config.to_prepare do
      ActionController::Base.send :include, Dotenv::Railtie::Env
    end


    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env'
      end
    end

  end
end

