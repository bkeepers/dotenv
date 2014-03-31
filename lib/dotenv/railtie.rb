require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    rake_tasks do
      desc 'Load environment settings from each *.env file'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env', *Dir.glob("#{Rails.root}/**/*.env")
      end
    end
  end
end

Dotenv.load ".env.#{Rails.env}", '.env', *Dir.glob("#{Rails.root}/**/*.env")
