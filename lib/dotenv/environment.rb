require 'dotenv/format_error'

module Dotenv
  class Environment < Hash
    LINE = /
      \A
      (?:export\s+)?    # optional export
      ([\w\.]+)         # key
      (?:\s*=\s*|:\s+?) # separator
      (                 # value begin
        '(?:\'|[^'])*'  #   single quoted value
        |               #   or
        "(?:\"|[^"])*"  #   double quoted value
        |               #   or
        [^#\n]+         #   unquoted value
      )                 # value end
      (?:\s*\#.*)?      # optional comment
      \z
    /x

    def initialize(filename)
      @filename = filename
      load
    end

    def load
      read.each do |line|
        if match = line.match(LINE)
          key, value = match.captures
          value = value.strip.sub(/\A(['"])(.*)\1\z/, '\2')
          value = value.gsub('\n', "\n").gsub(/\\(.)/, '\1') if $1 == '"'
          self[key] = value
        elsif line !~ /\A\s*(?:#.*)?\z/ # not comment or blank line
          raise FormatError, "Line #{line.inspect} doesn't match format"
        end
      end
    end

    def read
      File.read(@filename).split("\n")
    end

    def apply
      each { |k,v| ENV[k] = v }
    end
  end
end
