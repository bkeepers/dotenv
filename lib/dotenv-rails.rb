require 'dotenv/railtie'

# Load defaults from config/*.env or .env
Dotenv.load '.env'

# Override any existing variables if an environment-specific file exists
envs =  [".#{Rails.env}.env", ".env.#{Rails.env}"]
Dotenv.overload *envs

# Allow local overrides in .env.local or config/local.env
Dotenv.overload Rails.root.join('.local.env')

Spring.watch '.env' if defined?(Spring)
