module Dotenv
  class Environment < Hash
    def initialize(filename)
      @filename = filename
      load if File.exists? @filename
    end

    def load
      read.each do |line|
        self[$1] = $4 || $5 if line =~ /\A([\w_]+)(=|: ?)('([^']*)'|([^']*))\z/
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
