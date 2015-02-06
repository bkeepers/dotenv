require "dotenv/substitutions/variable"
if RUBY_VERSION > "1.8.7"
  require "dotenv/substitutions/command"
end

module Dotenv
  class FormatError < SyntaxError; end

  class Parser
    @@substitutions =
      Substitutions.constants.map { |const| Substitutions.const_get(const) }

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

    def self.call(string)
      new(string).call
    end

    def initialize(string)
      @string = string
    end

    def call
      @string.split("\n").inject({}) do |hash, line|
        if match = line.match(LINE)
          key, value = match.captures

          value ||= ""
          # Remove surrounding quotes
          value = value.strip.sub(/\A(['"])(.*)\1\z/, '\2')

          if Regexp.last_match(1) == '"'
            value = value.gsub('\n', "\n")
            # Unescape all characters except $ so variables can be escaped
            # properly
            value = value.gsub(/\\([^$])/, '\1')
          end

          if Regexp.last_match(1) != "'"
            @@substitutions.each do |proc|
              value = proc.call(value, hash)
            end
          end

          hash[key] = value
        elsif line.split.first == "export"
          # looks like you want to export after declaration, I guess that is ok
          unless line.split[1..-1].all? { |var| hash.member?(var) }
            fail FormatError,
                 "Line #{line.inspect} has a variable that is not set"
          end
        elsif line !~ /\A\s*(?:#.*)?\z/ # not comment or blank line
          fail FormatError, "Line #{line.inspect} doesn't match format"
        end
        hash
      end
    end
  end
end
