if defined?(RSpec.configure)
  RSpec.configure do |config|
    # Save ENV before the suite starts
    config.before(:suite) { Dotenv.save }

    # Restore ENV after each example
    config.after { Dotenv.restore }
  end
end

if defined?(ActiveSupport)
  ActiveSupport.on_load(:active_support_test_case) do
    # Save ENV when the test suite loads
    Dotenv.save

    ActiveSupport::TestCase.class_eval do
      # Restore ENV after each test
      setup { Dotenv.restore }
    end
  end
end
