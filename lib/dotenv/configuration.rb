module Dotenv
  class Configuration
    class DSL
      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
      end

      def string(name, options = {}, &default)
        configuration.add Variable.new(name, options, &default)
      end

      def integer(name, options = {}, &default)
        configuration.add Integer.new(name, options, &default)
      end

      def boolean(name, options = {}, &default)
        configuration.add Boolean.new(name, options, &default)
      end

      def eval(filename)
        contents = File.read(filename)
        super contents, binding, filename.to_s, 1
      end
      public :eval
    end

    attr_reader :env

    def initialize(env = ENV)
      @env = env
      extend accessors
    end

    def accessors
      @accessors ||= Module.new
    end

    def add(variable)
      accessors.send :define_method, variable.accessor_name do
        variable.accessor(self)
      end
    end

    class Variable
      attr_reader :name, :options

      def initialize(name, options = {}, &default)
        @name = name
        @options = options
        @default = default
      end

      def required?
        !!options[:required]
      end

      def accessor_name
        name
      end

      def accessor(context)
        cast(value(context)).tap do |result|
          raise ArgumentError, "#{name} is required" if required? && result.nil?
        end
      end

      def value(context)
        context.env.fetch(name.to_s.upcase) do
          if @default
            context.instance_eval(&@default)
          else
            options[:default]
          end
        end
      end

      def cast(value)
        value
      end
    end

    class Integer < Variable
      def cast(value)
        Integer(value) if value
      end
    end

    class Boolean < Variable
      VALUES = {
        nil => nil, '' => nil,
        '0' => false, 'false' => false, false => false,
        '1' => true, 'true' => true, true => true
      }

      def accessor_name
        "#{name}?"
      end

      def cast(value)
        VALUES.fetch(value) do
          raise ArgumentError, "invalid value for boolean: #{value.inspect}"
        end
      end
    end
  end
end
