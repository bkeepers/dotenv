require 'dotenv/railtie'

# Load defaults from config/*.env  or .env
Dotenv.load *Dir.glob("#{Rails.root}/config/**/*.env").push('.env')

# Override any existing variables if an environment-specific file exists
Dotenv.overload *Dir.glob("#{Rails.root}/config/**/*.env.#{Rails.env}").push(".env.#{Rails.env}")

# Allow local overrides in .env.local or config/local.env
Dotenv.overload Rails.root.join('.env.local'), Rails.root.join("config/local.env")
