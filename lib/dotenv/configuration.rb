module Dotenv
  class Configuration
    class DSL
      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
      end

      def desc(description)
        @last_description = description
      end

      def string(name, options = {}, &default)
        add Variable.new(name, options, &default)
      end

      def integer(name, options = {}, &default)
        add Integer.new(name, options, &default)
      end

      def boolean(name, options = {}, &default)
        add Boolean.new(name, options, &default)
      end

      def eval(filename)
        contents = File.read(filename)
        super contents, binding, filename.to_s, 1
      end
      public :eval

      def add(variable)
        variable.options[:description] ||= last_description
        configuration.add variable
      end

      def last_description
        @last_description.tap { @last_description = nil }
      end
    end

    attr_reader :env

    def initialize(env = ENV)
      @env = env
      @variables = {}
      extend accessors
    end

    def accessors
      @accessors ||= Module.new
    end

    def add(variable)
      @variables[variable.name] = variable
      accessors.send :define_method, variable.accessor_name do
        variable.accessor(self)
      end
    end

    def [](name)
      @variables[name]
    end

    class Variable
      attr_reader :name, :options

      def initialize(name, options = {}, &default)
        @name = name
        @options = options
        @default = default
      end

      def required?(context)
        if options[:required].respond_to?(:to_proc)
          context.instance_eval(&options[:required])
        else
          !!options[:required]
        end
      end

      def accessor_name
        name
      end

      def accessor(context)
        cast(value(context)).tap do |result|
          raise ArgumentError, "#{name} is required" if required?(context) && result.nil?
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
