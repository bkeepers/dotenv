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
      # Copied from https://github.com/heroku/netrc/blob/master/lib/netrc.rb#L54
      if @filename =~ /\.gpg$/
        decrypted = `gpg --batch --quiet --decrypt #{@filename}`
        if $?.success?
          decrypted
        else
          raise Error.new("Decrypting #{@filename} failed.") unless $?.success?
        end
      else
        File.read(@filename)
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
