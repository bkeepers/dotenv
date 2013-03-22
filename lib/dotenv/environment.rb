module Dotenv
  class Environment < Hash
    def initialize(filename)
      @filename = filename
      load
    end

    def load
      read.each do |line|
        if line =~ /\A(?:export\s+)?(\w+)(?:=|: ?)(.*)\z/
          key = $1
          case val = $2
          # Remove single quotes
          when /\A'(.*)'\z/ then self[key] = $1
          # Remove double quotes and unescape string preserving newline characters
          when /\A"(.*)"\z/ then self[key] = $1.gsub('\n', "\n").gsub(/\\(.)/, '\1')
          else self[key] = val
          end
        end
      end
    end

    def read
      File.read(@filename).split("\n")
    end

    def apply
      each { |k,v| ENV[k] ||= v }
    end
  end
end
