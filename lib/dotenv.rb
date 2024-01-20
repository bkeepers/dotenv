require "dotenv/parser"
require "dotenv/environment"
require "dotenv/missing_keys"

# The top level Dotenv module. The entrypoint for the application logic.
module Dotenv
  class << self
    attr_accessor :instrumenter
  end

  module_function

  def load(*filenames, **kwargs)
    parse(*filenames, **kwargs) do |env|
      instrument("dotenv.load", env: env) { env.apply }
    end
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def load!(*filenames)
    load(*filenames, ignore: false)
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(*filenames)
    load(*filenames, overwrite: true)
  end

  # same as `overload`, but raises Errno::ENOENT if any files don't exist
  def overload!(*filenames)
    load(*filenames, overwrite: true, ignore: false)
  end

  # returns a hash of parsed key/value pairs but does not modify ENV
  def parse(*filenames, overwrite: false, ignore: true, &block)
    filenames << ".env" if filenames.empty?
    filenames = filenames.reverse if overwrite

    filenames.reduce({}) do |hash, filename|
      begin
        env = Environment.new(File.expand_path(filename), overwrite: overwrite)
        env = block.call(env) if block
      rescue Errno::ENOENT
        raise unless ignore
      end

      hash.merge! env || {}
    end
  end

  def instrument(name, payload = {}, &block)
    if instrumenter
      instrumenter.instrument(name, payload, &block)
    else
      yield
    end
  end

  def require_keys(*keys)
    missing_keys = keys.flatten - ::ENV.keys
    return if missing_keys.empty?
    raise MissingKeys, missing_keys
  end

  def ignoring_nonexistent_files
    yield
  rescue Errno::ENOENT
  end
end
