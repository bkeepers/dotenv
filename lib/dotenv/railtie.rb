module Dotenv
  class Railtie < Rails::Railtie
    include Rake::DSL if defined?(Rake)

    rake_tasks do
      desc 'Load environment settings from .env'
      task :dotenv do
        Dotenv.load ".env.#{Rails.env}", '.env'
      end
    end

    class << self
      def no_warn!
        @no_warn = true
      end

      def no_warn?
        @no_warn
      end
    end

    initializer 'dotenv', :group => :all do
      unless self.class.no_warn?
        warn <<-EOF
[DEPRECATION] Autoloading for dotenv has been moved to the `dotenv-rails` gem. Change your Gemfile to:
  gem 'dotenv-rails', :groups => [:development, :test]
EOF
      end
    end
  end
end

Dotenv.load ".env.#{Rails.env}", '.env'
