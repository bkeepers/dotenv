require 'rubygems'
require "dotenv/extensions/file_handlers"

# Dotenv extension handling
module Dotenv
  module Extensions
    class << self

      # Register all existing extensions.
      def register
        modules = extension_gems.map do |gem|
          require_gem(gem)
        end.compact

        modules.each do |m| 
          puts "registering #{m}"
          register_file_handler(m)
        end
      end  

      # Look for all gems that start with "dotenv-"
      def extension_gems
        dotenv_gems = Gem::Specification.select{|g|g.name =~ /^dotenv-/}
      end

      # Register file handlers
      def register_file_handler(m)
        if m.extensions.include? :file_handler
          file_handler = Object.const_get("#{m.name}::FileHandler")
          Dotenv::Extensions::FileHandlers.register(file_handler) 
        end
      end

      # Require the given gem, returns its module
      def require_gem(gem)
        module_name = gem.name.match(/^dotenv-(.+)/).captures[0]
        require "dotenv/#{module_name}"
        Object.const_get "::Dotenv::#{module_name.capitalize}"
      end
    end
  end
end
