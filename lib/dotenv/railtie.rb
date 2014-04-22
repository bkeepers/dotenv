require 'dotenv'

module Dotenv
  class Railtie < Rails::Railtie
    rake_tasks do
      task :dotenv do
        # If the dotenv task is defined, then dotenv has already been loaded.
        warn "The `dotenv` task is no longer needed and will be removed in 1.0."
      end
    end
  end
end
