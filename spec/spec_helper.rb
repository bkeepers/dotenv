require 'dotenv'

RSpec.configure do |config|
  # Restore the state of ENV after each spec
  config.before { @env = ENV.to_h }
  config.after  { ENV.replace @env }
end
