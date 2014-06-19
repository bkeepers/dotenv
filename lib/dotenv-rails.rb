require 'dotenv/railtie'

env_file = Rails.root.join(".env.#{Rails.env}")
if File.exist?(env_file) && !defined?(Dotenv::Deployment)
  warn "Auto-loading of `#{env_file}` will be removed in 1.0. See " +
    "https://github.com/bkeepers/dotenv-deployment if you would like to " +
    "continue using this feature."
  Dotenv.load env_file
end

Dotenv.load Rails.root.join('.env')

Spring.watch Rails.root.join('.env') if defined?(Spring)
