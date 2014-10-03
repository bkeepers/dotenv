require 'dotenv/railtie'

Dotenv.instrumenter = ActiveSupport::Notifications

if defined?(Spring)
  ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename
  end
end

env_file = Rails.root.join(".env.#{Rails.env}")
if File.exist?(env_file) && !defined?(Dotenv::Deployment)
  warn "Auto-loading of `#{env_file}` will be removed in 1.0. See " +
    "https://github.com/bkeepers/dotenv-deployment if you would like to " +
    "continue using this feature."
  Dotenv.load env_file
end

Dotenv.load Rails.root.join('.env')
