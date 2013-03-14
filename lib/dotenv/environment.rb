require 'foreman/env'
module Dotenv
  class Environment < Hash
    def initialize(filename)
      @filename = filename
      load if File.exists? @filename
    end

    def load
      Foreman::Env.new(@filename).entries { |name, value| self[name] = value }
    end

    def apply
      each { |k,v| ENV[k] ||= v }
    end
  end
end
