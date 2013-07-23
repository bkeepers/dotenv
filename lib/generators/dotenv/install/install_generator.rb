module Dotenv
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def create_configuration
        add_file('.env')
      end

      def ignore_configuration
        if File.exists?(".gitignore")
          append_to_file(".gitignore") do
            <<-EOF.strip_heredoc

            # Ignore dotenv configurations
            .env
            EOF
          end
        end
      end
    end
  end
end
