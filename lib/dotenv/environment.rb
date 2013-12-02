require 'dotenv/format_error'
require 'dotenv/substitutions/variable'
if RUBY_VERSION > '1.8.7'
  require 'dotenv/substitutions/command'
end

module Dotenv
  class Environment < Hash
    @@substitutions = Substitutions.constants.map { |const| Substitutions.const_get(const) }

    LINE = /
      \A
      (?:export\s+)?    # optional export
      ([\w\.]+)         # key
      (?:\s*=\s*|:\s+?) # separator
      (                 # optional value begin
        '(?:\'|[^'])*'  #   single quoted value
        |               #   or
        "(?:\"|[^"])*"  #   double quoted value
        |               #   or
        [^#\n]+         #   unquoted value
      )?                # value end
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

          value ||= ''
          # Remove surrounding quotes
          value = value.strip.sub(/\A(['"])(.*)\1\z/, '\2')

          if $1 == '"'
            value = value.gsub('\n', "\n")
            # Unescape all characters except $ so variables can be escaped properly
            value = value.gsub(/\\([^$])/, '\1')
          end

          @@substitutions.each do |proc|
            value = proc.call(value, self)
          end

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
      each { |k,v| ENV[k] ||= v }
    end
  end
end
