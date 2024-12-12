require "dotenv/substitutions/variable"
require "dotenv/substitutions/command" if RUBY_VERSION > "1.8.7"

module Dotenv
  # Error raised when encountering a syntax error while parsing a .env file.
  class FormatError < SyntaxError; end

  # Parses the `.env` file format into key/value pairs.
  # It allows for variable substitutions, command substitutions, and exporting of variables.
  class Parser
    @substitutions = [
      Dotenv::Substitutions::Variable,
      Dotenv::Substitutions::Command
    ]

    LINE = /
      (?:^|\A)              # beginning of line
      \s*                   # leading whitespace
      (?:export\s+)?        # optional export
      ([\w.]+)              # key
      (?:\s*=\s*?|:\s+?)    # separator
      (                     # optional value begin
        \s*'(?:\\'|[^'])*'  #   single quoted value
        |                   #   or
        \s*"(?:\\"|[^"])*"  #   double quoted value
        |                   #   or
        [^\#\r\n]+          #   unquoted value
      )?                    # value end
      \s*                   # trailing whitespace
      (?:\#.*)?             # optional comment
      (?:$|\z)              # end of line
    /x

    class << self
      attr_reader :substitutions

      def call(...)
        new(...).call
      end
    end

    def initialize(string, overwrite: false)
      @string = string
      @hash = {}
      @overwrite = overwrite
    end

    def call
      # Convert line breaks to same format
      lines = @string.gsub(/\r\n?/, "\n")
      # Process matches
      lines.scan(LINE).each do |key, value|
        # Skip parsing values that will be ignored
        next if ignore?(key)

        @hash[key] = parse_value(value || "")
      end
      # Process non-matches
      lines.gsub(LINE, "").split(/[\n\r]+/).each do |line|
        parse_line(line)
      end
      @hash
    end

    private

    # Determine if the key can be ignored.
    def ignore?(key)
      !@overwrite && key != "DOTENV_LINEBREAK_MODE" && ENV.key?(key)
    end

    def parse_line(line)
      if line.split.first == "export"
        if variable_not_set?(line)
          raise FormatError, "Line #{line.inspect} has an unset variable"
        end
      end
    end

    QUOTED_STRING = /\A(['"])(.*)\1\z/m
    def parse_value(value)
      # Remove surrounding quotes
      value = value.strip.sub(QUOTED_STRING, '\2')
      maybe_quote = Regexp.last_match(1)

      # Expand new lines in double quoted values
      value = expand_newlines(value) if maybe_quote == '"'

      # Unescape characters and performs substitutions unless value is single quoted
      if maybe_quote != "'"
        value = unescape_characters(value)
        self.class.substitutions.each { |proc| value = proc.call(value, @hash) }
      end

      value
    end

    def unescape_characters(value)
      value.gsub(/\\([^$])/, '\1')
    end

    def expand_newlines(value)
      if (@hash["DOTENV_LINEBREAK_MODE"] || ENV["DOTENV_LINEBREAK_MODE"]) == "legacy"
        value.gsub('\n', "\n").gsub('\r', "\r")
      else
        value.gsub('\n', "\\\\\\n").gsub('\r', "\\\\\\r")
      end
    end

    def variable_not_set?(line)
      !line.split[1..].all? { |var| @hash.member?(var) }
    end
  end
end
