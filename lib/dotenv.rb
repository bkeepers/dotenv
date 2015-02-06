require "dotenv/parser"
require "dotenv/environment"

module Dotenv
  extend self

  attr_accessor :instrumenter

  def load(*filenames)
    with(*filenames) do |f|
      if File.exist?(f)
        env = Environment.new(f)
        instrument("dotenv.load", :env => env) { env.apply }
      end
    end
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def load!(*filenames)
    with(*filenames) do |f|
      env = Environment.new(f)
      instrument("dotenv.load", :env => env) { env.apply }
    end
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(*filenames)
    with(*filenames) do |f|
      if File.exist?(f)
        env = Environment.new(f)
        instrument("dotenv.overload", :env => env) { env.apply! }
      end
    end
  end

  # Internal: Helper to expand list of filenames.
  #
  # Returns a hash of all the loaded environment variables.
  def with(*filenames, &block)
    filenames << ".env" if filenames.empty?

    filenames.reduce({}) do |hash, filename|
      hash.merge! block.call(File.expand_path(filename)) || {}
    end
  end

  def instrument(name, payload = {}, &block)
    if instrumenter
      instrumenter.instrument(name, payload, &block)
    else
      block.call
    end
  end
end
