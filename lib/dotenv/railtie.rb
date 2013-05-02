require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    module Env
      def env
        Dotenv.env
      end
    end

    # Load .env immediately
    Dotenv.load ".env.#{Rails.env}", '.env'

    # Expose all the environment variables in config.env
    config.env = Dotenv.env

    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env'
      end
    end

  end
end

[:action_controller, :action_view, :active_record, :action_mailer].each do |framework|
  ActiveSupport.on_load(framework) do |base|
    base.class_eval do
      extend Dotenv::Railtie::Env
      include Dotenv::Railtie::Env
    end
  end
end
