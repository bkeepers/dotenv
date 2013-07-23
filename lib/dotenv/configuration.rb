module Dotenv
  # A wrapper around the ENV hash to expose properties as methods.
  class Configuration < Hash
    def initialize(env)
      super().replace(env)
    end

    def method_missing(method, *)
      fetch(method.to_s.upcase) { nil }
    end
  end
end
