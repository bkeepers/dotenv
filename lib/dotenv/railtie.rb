require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        filenames = [".env.#{Rails.env}", '.env']
        Dotenv.load *(Dotenv.override? ? filenames.reverse : filenames)
      end
    end
  end
end

filenames = [".env.#{Rails.env}", '.env']
Dotenv.load *(Dotenv.override? ? filenames.reverse : filenames)
