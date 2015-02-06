require "dotenv"

RSpec.configure do |config|
  # Restore the state of ENV after each spec
  config.before { @env_keys = ENV.keys }
  config.after  { ENV.delete_if { |k, _v| !@env_keys.include?(k) } }
end

def fixture_path(name)
  File.join(File.expand_path("../fixtures", __FILE__), name)
end
