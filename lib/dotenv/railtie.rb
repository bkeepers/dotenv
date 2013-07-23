require 'dotenv'

DOTENV_FILES=[".env.#{Rails.env}", '.env', '/etc/environment']

module Dotenv
  class Railtie < Rails::Railtie
    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load *DOTENV_FILES
      end
    end
  end
end

Dotenv.load *DOTENV_FILES
