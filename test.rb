require 'dotenv'
def display_envs()
  puts
  puts "RACK_ENV=#{ENV['RACK_ENV']}"
  puts "DB_NAME=#{ENV['DB_NAME']}"
  puts
end

puts "Before loading .env..."
display_envs


Dotenv.load

puts "After loading .env..."
display_envs
