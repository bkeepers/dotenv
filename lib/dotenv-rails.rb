require 'dotenv/railtie'

env_file = ".env.#{Rails.env}"
if File.exists?(env_file) && !defined?(Dotenv::Deployment)
  warn "Auto-loading of `#{env_file}` will be removed in 1.0. See " +
    "https://github.com/bkeepers/dotenv-deployment if you would like to " +
    "continue using this feature."
  Dotenv.load ".env.#{Rails.env}"
end

Dotenv.load '.env'
