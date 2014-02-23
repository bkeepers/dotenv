require 'dotenv/railtie'

Dotenv.load ".env.#{Rails.env}", '.env'
