require "dotenv"

module Dotenv
  class CLI
    attr_reader :argv

    def initialize(argv = [])
      @argv = argv.dup
    end

    def run
      filenames = if pos = argv.index("-f")
                    # drop the -f
                    argv.delete_at pos
                    # parse one or more comma-separated .env files
                    require "csv"
                    CSV.parse_line argv.delete_at(pos)
                  else
                    []
      end

      begin
        Dotenv.load! *filenames
      rescue Errno::ENOENT => e
        abort e.message
      else
        exec *argv unless argv.empty?
      end
    end
  end
end
