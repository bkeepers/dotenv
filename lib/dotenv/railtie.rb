require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env'
      end
    end
  end
end

Dotenv.load ".env.#{Rails.env}", '.env'
