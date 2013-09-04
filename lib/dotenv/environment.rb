require 'dotenv/format_error'

module Dotenv
  class Environment < Hash
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
    VARIABLE = /
      (\\)?
      (\$)
      (              # collect braces with var for sub
        \{?          # allow brace wrapping
        ([A-Z0-9_]+) # match the variable
        \}?          # closing brace
      )
    /xi

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

          # Process embedded variables
          value.scan(VARIABLE).each do |parts|
            if parts.first == '\\'
              replace = parts[1...-1].join('')
            else
              replace = self.fetch(parts.last) { ENV[parts.last] }
            end

            value = value.sub(parts[0...-1].join(''), replace || '')
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
      if self.key?('DOTENV_OVERRIDE') && self['DOTENV_OVERRIDE']=="yes"
        each { |k,v| ENV[k] = v }
      else
        each { |k,v| ENV[k] ||= v }
      end
    end
  end
end
