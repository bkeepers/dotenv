require 'dotenv'

module Fixtures
  def fixture_path(name)
    File.join(File.expand_path('../fixtures', __FILE__), name)
  end
end

RSpec.configure do |config|
  # Restore the state of ENV after each spec
  config.before { @env = ENV.to_h }
  config.after  { ENV.replace @env }
  config.include Fixtures
end
