module Dotenv
  class Environment < Hash
    LINE = /\A(?:export\s+)?([\w\.]+)(?:=|: ?)(.*)\z/

    def initialize(filename)
      @filename = filename
      load
    end

    def load
      read.each do |line|
        if match = line.match(LINE)
          key, value = match.to_a.drop(1)
          value = value.sub(/\A(['"])(.*)\1\z/, '\2')
          value = value.gsub('\n', "\n").gsub(/\\(.)/, '\1') if $1 == '"'
          self[key] = value
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
