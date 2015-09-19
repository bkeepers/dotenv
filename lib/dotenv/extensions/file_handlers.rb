module Dotenv
  module Extensions
    class FileHandlers
      class << self
        def register(handler)
          read_method = handler.method(:read)
          fail "No read method defined on file handler #{handler}" unless read_method
          fail "#{handler}.read must have arity of 1" unless read_method.arity == 1

          if handler.respond_to? :file_types
            handler.file_types.each do |type|
              existing_handler = file_types[type]
              if existing_handler.nil?
                file_types[type] = handler  
              else
                fail Error, "File type #{file} cannot be registered to #{handler}, it is already registered to #{existing_handler}"
              end
            end
          end
        end

        def file_types 
          @handlers ||= {}
        end
      end
    end
  end
end
