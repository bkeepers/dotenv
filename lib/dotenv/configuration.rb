module Dotenv
  module Configuration
    def self.extended(base)
      base.send :include, base.accessors
    end

    def string(name, options = {})
      define_accessor(name, options) { |value| value }
    end

    def integer(name, options = {})
      define_accessor(name, options) { |value| Integer(value) if value }
    end

    BOOLEANS = {
      nil => nil, '' => nil,
      '0' => false, 'false' => false,
      '1' => true, 'true' => true
    }

    def boolean(name, options = {})
      options = {:suffix => "?"}.merge(options)
      define_accessor(name, options) do |value|
        BOOLEANS.fetch(value) do
          raise ArgumentError, "invalid value for boolean: #{value.inspect}"
        end
      end
    end

    # Internal: Module that the accessors get defined on
    def accessors
      @accessors ||= Module.new
    end

    # Internal: Helper method for defining a new accessor
    #
    # name - the name of the config variable.
    # options[:suffix] - the suffix that gets append to the method name
    def define_accessor(name, options = {}, &block)
      accessors.send :define_method, "#{name}#{options[:suffix]}" do
        value = env.fetch(self.class.variable_name(name)) { options[:default] }
        raise ArgumentError, "#{name} is required" if options[:required] && value.nil?
        block.call(value)
      end
    end

    def variable_name(name)
      name.to_s.upcase
    end
  end
end
