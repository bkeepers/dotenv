require "dotenv"
require "dotenv/version"
require "dotenv/template"
require "optparse"

module Dotenv
  # The command line interface
  class CLI < OptionParser
    attr_reader :argv, :filenames, :overload

    def initialize(argv = [])
      @argv = argv.dup
      @filenames = []
      @ignore = false
      @overload = false

      super("Usage: dotenv [options]")
      separator ""

      on("-f FILES", Array, "List of env files to parse") do |list|
        @filenames = list
      end

      on("-i", "--ignore", "ignore missing env files") do
        @ignore = true
      end

      on("-o", "--overload", "override existing ENV variables") do
        @overload = true
      end

      on("-h", "--help", "Display help") do
        puts self
        exit
      end

      on("-v", "--version", "Show version") do
        puts "dotenv #{Dotenv::VERSION}"
        exit
      end

      on("-t", "--template=FILE", "Create a template env file") do |file|
        template = Dotenv::EnvTemplate.new(file)
        template.create_template
      end

      order!(@argv)
    end

    def run
      meth = "load"
      meth = "overload" if @overload
      meth = "#{meth}!" unless @ignore

      Dotenv.public_send(meth, *@filenames)
    rescue Errno::ENOENT => e
      abort e.message
    else
      exec(*@argv) unless @argv.empty?
    end
  end
end
