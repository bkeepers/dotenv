require "English"

module Dotenv
  module Substitutions
    # Substitute "\$" to "$"
    #
    module Unescape
      class << self
        ESCAPED_DOLLARS = /\\\$/
        ESCAPED_BACKSLASHES =  /\\\\/

        def call(value, _env)
          value.gsub(ESCAPED_DOLLARS, '$').gsub(ESCAPED_BACKSLASHES, "\\")
        end
      end
    end
  end
end
