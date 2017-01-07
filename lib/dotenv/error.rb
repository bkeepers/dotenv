module Dotenv
  # Throws error for unsupplied environment keys
  class MissingKeys < StandardError
    def initialize(keys)
      super("Missing required configuration keys: #{keys.inspect}")
    end
  end
end
