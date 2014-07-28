require 'dotenv/railtie'

# Load defaults from config/*.env or .env
Dotenv.load Rails.root.join('.env')

# Override any existing variables if an environment-specific file exists
envs =  [
  Rails.root.join(".#{Rails.env}.env"),
  Rails.root.join(".env.#{Rails.env}"
]
Dotenv.overload *envs

# Allow local overrides in .env.local or config/local.env
Dotenv.overload Rails.root.join('.local.env'), Rails.root.join('.local.env')

Spring.watch Rails.root.join('.env') if defined?(Spring)
