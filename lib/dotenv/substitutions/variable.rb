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
          (([^\\]|^)\\)?        # is it escaped with a backslash but not escaped backslash?
          (\$)                  # literal $
          \{?                   # allow brace wrapping
          ([A-Z0-9_]+)          # match the variable
          \}?                   # closing brace
        /xi

        def call(value, env)
          value.gsub(VARIABLE) do |variable|
            match = $LAST_MATCH_INFO

            if match[1]
              match[2] + variable[match[1].size .. -1]
            else
              env.fetch(match[4]) { ENV[match[4]] }
            end
          end
        end
      end
    end
  end
end
