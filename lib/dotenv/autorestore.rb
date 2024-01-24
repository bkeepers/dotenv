# Automatically restore `ENV` to its original state after

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
    ActiveSupport::TestCase.class_eval do
      # Save ENV before each test
      setup { Dotenv.save }

      # Restore ENV after each test
      teardown { Dotenv.restore }
    end
  end
end
