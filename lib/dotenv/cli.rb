require "dotenv"
require "dotenv/version"
require "dotenv/template"
require "optparse"

module Dotenv
  # The CLI is a class responsible of handling all the command line interface
  # logic.
  class CLI
    attr_reader :argv, :filenames, :overload

    def initialize(argv = [])
      @argv = argv.dup
      @filenames = []
      @overload = false

      @parser = OptionParser.new do |parser|
        parser.banner = "Usage: dotenv [options]"
        parser.separator ""

        parser.on("-f FILES", Array, "List of env files to parse") do |list|
          @filenames = list
        end

        parser.on("-o", "--overload", "override existing ENV variables") do
          @overload = true
        end

        parser.on("-h", "--help", "Display help") do
          puts parser
          exit
        end

        parser.on("-v", "--version", "Show version") do
          puts "dotenv #{Dotenv::VERSION}"
          exit
        end

        parser.on("-t", "--template=FILE", "Create a template env file") do |file|
          template = Dotenv::EnvTemplate.new(file)
          template.create_template
        end
      end

      @parser.order!(@argv)
    end

    def run
      load_dotenv(@overload, @filenames)
    rescue Errno::ENOENT => e
      abort e.message
    else
      exec(*@argv) unless @argv.empty?
    end

    private

    def load_dotenv(overload, filenames)
      if overload
        Dotenv.overload!(*filenames)
      else
        Dotenv.load!(*filenames)
      end
    end
  end
end
