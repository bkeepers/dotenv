desc 'Load environment settings from .env'
task :dotenv do
  require 'dotenv'
  Dotenv.load
end

namespace :dotenv do
  desc 'Prompts for values and generates an environment file from .env.example'
  task :generate, :target_env do |t, args|
    require 'dotenv/generator'
    
    g = Dotenv::Generator.new(args[:target_env])
    g.prompt
    
    if g.values.empty?
      STDOUT.puts "No examples or existing keys found. Please create a .env.example file or #{g.target_file} file before running the generator."
      exit
    end
    
    STDOUT.puts "Writing to file #{g.target_file}"
    g.write
  end
end

task :environment => :dotenv
