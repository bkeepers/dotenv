require 'open3'

module Dotenv
  class ShellParser
    SOURCE = File.expand_path('../../bin/dotenv-source', __dir__)

    # Source the given file and return Hash of new environment variables
    def source(file)
      output, error, status = Open3.capture3("#{SOURCE} #{file}")
      raise ArgumentError, error unless status.success?
      Hash[output.split("\u0000").map { |line| line.split("=", 2) } - ENV.to_a]
    end
  end
end
