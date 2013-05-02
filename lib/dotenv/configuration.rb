module Dotenv
  class UndefinedVariable < Exception
    def initialize(name)
      super "Undefined ENV variable: #{name}"
    end
  end

  # A wrapper around the ENV hash to expose properties as methods.
  class Configuration < Hash

    Suffixes = [nil, '?']

    def initialize(env)
      super().replace(env)
    end

    def respond_to?(method_name)
      name, suffix = variable_name(method_name)
      (key?(name) && Suffixes.include?(suffix)) || super
    end

  private

    def method_missing(method_name, *)
      name, suffix = variable_name(method_name)
      send "variable#{suffix}", name
    end

    def variable(name)
      fetch(name) { raise UndefinedVariable, name }
    end

    def variable?(name)
      key?(name)
    end

    # Internal: Turn a method name into a variable name and a suffix.
    def variable_name(method_name)
      match = method_name.to_s.match(/^(.*?)([?])?$/).to_a
      [match[1].upcase, match[2]]
    end
  end
end
