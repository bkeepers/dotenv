require "dotenv"
require "dotenv/version"
require "optparse"

module Dotenv
  # The CLI is a class responsible of handling all the command line interface
  # logic.
  class CLI
    attr_reader :argv, :exec_args, :parser_args, :filenames

    def initialize(argv = [])
      @argv = argv.dup
      @filenames = []
      @flag_matchers = []
    end

    def run
      parse_argv!(@argv)

      begin
        Dotenv.load!(*@filenames)
      rescue Errno::ENOENT => e
        abort e.message
      else
        exec(*@exec_args) unless @exec_args.empty?
      end
    end

    private

    def parse_argv!(argv)
      parser = create_option_parser
      add_options(parser, @flag_matchers)
      @parser_args, @exec_args = split_argv(argv.join(" "), @flag_matchers)
      parser.parse! @parser_args

      @filenames
    end

    def add_options(parser, flag_matchers)
      add_files_option(parser, flag_matchers)
      add_help_option(parser, flag_matchers)
      add_version_option(parser, flag_matchers)
    end

    def add_files_option(parser, flag_matchers)
      flag_matchers.push("-f \\S+")
      parser.on("-f FILES", Array, "List of env files to parse") do |list|
        @filenames = list
      end
    end

    def add_help_option(parser, flag_matchers)
      flag_matchers.push("-h", "--help")
      parser.on("-h", "--help", "Display help") do
        puts parser
        exit
      end
    end

    def add_version_option(parser, flag_matchers)
      flag_matchers.push("-v", "--version")
      parser.on("-v", "--version", "Show version") do
        puts "dotenv #{Dotenv::VERSION}"
        exit
      end
    end

    # Detect dotenv flags vs executable args so we can parse properly and still
    # take advantage of OptionParser for dotenv flags
    def split_argv(arg_string, matchers)
      matcher     = /^((?:#{matchers.join("|")})\s?)?(.+)?$/
      data        = matcher.match(arg_string)
      dotenv_args = []
      exec_args   = []

      unless data.nil?
        dotenv_args = (!data[1].nil? ? data[1].split(" ") : [])
        exec_args   = (!data[2].nil? ? data[2].split(" ") : [])
      end

      [dotenv_args, exec_args]
    end

    def create_option_parser
      OptionParser.new do |parser|
        parser.banner = "Usage: dotenv [options]"
        parser.separator ""
      end
    end
  end
end
