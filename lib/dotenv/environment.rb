module Dotenv
  # This class inherits from Hash and represents the environment into which
  # Dotenv will load key value pairs from a file.
  class Environment < Hash
    attr_reader :filename, :overwrite

    def initialize(filename, overwrite: false)
      super()
      @filename = filename
      @overwrite = overwrite
      load
    end

    def load
      update Parser.call(read, overwrite: overwrite)
    end

    def read
      File.open(@filename, "rb:bom|utf-8", &:read)
    end
  end
end
