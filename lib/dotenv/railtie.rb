require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env'
      end

      namespace :dotenv do
        desc 'Prompts for values and generates a .env.RAILS_ENV file from .env.example'
        task :generate, [:target_env] => :environment do |t, args|
          require 'dotenv/generator'
          g = Dotenv::Generator.new(args[:target_env] || Rails.env)
          g.prompt
          if g.values.empty?
            STDOUT.puts "No examples or existing keys found. Please create a .env.example file or #{g.target_file} file before running the generator."
            exit
          end
          STDOUT.puts "Writing to file #{g.target_file}"
          g.write
        end
      end
    end
  end
end

Dotenv.load ".env.#{Rails.env}", '.env'
