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
          (\\\\)?       # is it preceded by a literal backslash escape?
          (\\)?         # is it escaped with a backslash?
          (\$)          # literal $
          (?!\()        # shouldn't be followed by parenthesis
          \{?           # allow brace wrapping
          ([A-Z0-9_]+)? # optional alpha nums
          \}?           # closing brace
        /xi

        def call(value, env)
          value.gsub(VARIABLE) do |variable|
            match = $LAST_MATCH_INFO

            if match[1] == "\\\\"
              "\\" + (env[match[4]] || ENV[match[4]] || "")
            elsif match[2] == "\\"
              variable[1..]
            elsif match[4]
              env[match[4]] || ENV[match[4]] || ""
            else
              variable
            end
          end
        end
      end
    end
  end
end
