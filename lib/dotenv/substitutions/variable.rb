require "English"

module Dotenv
  module Substitutions
    # Substitute variables in a value.
    #
    #   HOST=example.com
    #   URL="https://$HOST"
    #
    module Variable
      class << self
        VARIABLE = /
          (\\)?         # is it escaped with a backslash?
          (\$)          # literal $
          (?!\()        # shouldnt be followed by paranthesis
          \{?           # allow brace wrapping
          (?(1)[A-Z0-9_]*|([A-Z0-9_]+)) # if escaped, no need to match with alpha nums
          \}?           # closing brace
        /xi

        def call(value, env)
          value.gsub(VARIABLE) do |variable|
            match = $LAST_MATCH_INFO

            if match[1] == '\\'
              variable[1..-1]
            else
              env.fetch(match[3]) { ENV[match[3]] }
            end
          end
        end
      end
    end
  end
end
