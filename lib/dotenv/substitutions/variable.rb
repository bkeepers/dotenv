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
          (\\)?          # is it escaped with a backslash?
          (\$)           # literal $
          (              # collect braces with var for sub
            \{?          # allow brace wrapping
            ([A-Z0-9_]+) # match the variable
            \}?          # closing brace
          )
        /xi

        def call(value, env)
          # Process embedded variables
          value.scan(VARIABLE).each do |parts|
            if parts.first == '\\'
              # Variable is escaped, don't replace it.
              replace = parts[1...-1].join('')
            else
              # Replace it with the value from the environment
              replace = env.fetch(parts.last) { ENV[parts.last] }
            end

            value = value.sub(parts[0...-1].join(''), replace || '')
          end

          value
        end
      end

    end

  end
end
