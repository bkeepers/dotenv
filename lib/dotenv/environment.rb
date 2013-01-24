module Dotenv
  class Environment < Hash
    def initialize(filename)
      @filename = filename
      load if File.exists? @filename
    end

    def load
      read.each do |line|
        self[$1] = $2 || $3 if line =~ /\A(\w+)(?:=|: ?)(?:'([^']*)'|([^']*))\z/
      end
    end

    def read
      File.read(@filename).split("\n")
    end

    def apply
      each { |k,v| ENV[k] ||= substitute(v) }
    end

    def substitute(value)
      value.gsub(/\$(\w+)/) { |m| ENV[$1] }
    end
  end
end
