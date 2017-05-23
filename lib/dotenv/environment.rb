module Dotenv
  # This class inherits from Hash and represents the environment into which
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
      if defined? Sekrets
        if @filename =~ /\.enc$/
          Sekrets.read(@filename) || raise(Errno::ENOENT)
        else
          File.open(@filename, "rb:bom|utf-8", &:read)
        end
      else
        File.open(@filename, "rb:bom|utf-8", &:read)
      end
    end

    def apply
      each { |k, v| ENV[k] ||= v }
    end

    def apply!
      each { |k, v| ENV[k] = v }
    end
  end
end
