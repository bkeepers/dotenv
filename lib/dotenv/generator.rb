module Dotenv
  # Generates a .env string from an env hash
  class Generator
    class << self
      def call(hash, options = {})
        hash.map do |k, v|
          v = v.inspect
          v.gsub!("$", "\\$") unless options[:unsafe]
          "#{k}=#{v}"
        end.join("\n") << "\n"
      end
    end
  end
end
