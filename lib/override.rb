module Dotenv
  @@override = true
end

require (defined?(Rails) ? 'dotenv-rails' : 'dotenv')
