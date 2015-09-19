require "dotenv/extensions/file_handlers"
module Dotenv
  # This class inherits from Hash and represents the environemnt into which
  # Dotenv will load key value pairs from a file.
  class Environment < Hash
    attr_reader :filename

    def initialize(filename)
      @filename = filename
      load
    end

    def load
      update Parser.call(read)
    end

    def read
      Extensions::FileHandlers.file_types.each do |type, handler|
        if @filename =~ /#{type}$/
          return handler.read(@filename)
        end
      end
      File.read(@filename)
    end

    def apply
      each { |k, v| ENV[k] ||= v }
    end

    def apply!
      each { |k, v| ENV[k] = v }
    end
  end
end
