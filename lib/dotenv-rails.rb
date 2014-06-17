require 'dotenv/railtie'

# Load defaults from config/*.env or .env
Dotenv.load *Dir.glob("#{Rails.root}/config/**/*.env").push('.env')

# Override any existing variables if an environment-specific file exists
envs = *Dir.glob("#{Rails.root}/config/**/*.#{Rails.env}.env").push(
  ".#{Rails.env}.env",
  ".env.#{Rails.env}"
)
Dotenv.overload *envs

# Allow local overrides in .env.local or config/local.env
Dotenv.overload Rails.root.join('.env.local'), Rails.root.join("config/local.env")
