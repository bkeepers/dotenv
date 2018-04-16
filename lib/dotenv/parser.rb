require "dotenv/substitutions/variable"
require "dotenv/substitutions/command" if RUBY_VERSION > "1.8.7"

module Dotenv
  class FormatError < SyntaxError; end

  # This class enables parsing of a string for key value pairs to be returned
  # and stored in the Environment. It allows for variable substitutions and
  # exporting of variables.
  class Parser
    @substitutions =
      [Dotenv::Substitutions::Variable, Dotenv::Substitutions::Command]

    LINE = /
      \s*
      (?:export\s+)?    # optional export
      ([\w\.]+)         # key
      (?:\s*=\s*|:\s+?) # separator
      (                 # optional value begin
        '(?:\\'|[^'])*'  #   single quoted value
        |               #   or
        "(?:\\"|[^"])*"  #   double quoted value
        |               #   or
        [^#\r\n]+         #   unquoted value
      )?                # value end
      \s*
      (?:\#.*)?         # optional comment
    /x

    class << self
      attr_reader :substitutions

      def call(string)
        new(string).call
      end
    end

    def initialize(string)
      @string = string
      @hash = {}
    end

    def call
      # Process matches
      @string.scan(LINE).each do |key, value|
        @hash[key] = parse_value(value || "")
      end
      # Process non-matches
      @string.gsub(LINE, "").split(/[\n\r]+/).each do |line|
        parse_line(line)
      end
      @hash
    end

    private

    def parse_line(line)
      if line.split.first == "export"
        if variable_not_set?(line)
          raise FormatError, "Line #{line.inspect} has an unset variable"
        end
      end
    end

    def parse_value(value)
      # Remove surrounding quotes
      value = value.strip.sub(/\A(['"])(.*)\1\z/m, '\2')

      if Regexp.last_match(1) == '"'
        value = unescape_characters(expand_newlines(value))
      end

      if Regexp.last_match(1) != "'"
        self.class.substitutions.each do |proc|
          value = proc.call(value, @hash)
        end
      end
      value
    end

    def unescape_characters(value)
      value.gsub(/\\([^$])/, '\1')
    end

    def expand_newlines(value)
      value.gsub('\n', "\n").gsub('\r', "\r")
    end

    def variable_not_set?(line)
      !line.split[1..-1].all? { |var| @hash.member?(var) }
    end
  end
end
