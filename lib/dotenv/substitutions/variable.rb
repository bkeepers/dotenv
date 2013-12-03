module Dotenv
  module Substitutions
    module Variable
      class << self

        VARIABLE = /
          (\\)?
          (\$)
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
              replace = parts[1...-1].join('')
            else
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
