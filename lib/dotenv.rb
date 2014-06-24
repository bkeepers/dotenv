require 'dotenv/parser'
require 'dotenv/environment'

module Dotenv
  extend self

  def load(*filenames)
    with(*filenames) { |f| Environment.new(f).apply if File.exist?(f) }
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def load!(*filenames)
    with(*filenames) { |f| Environment.new(f).apply }
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(*filenames)
    with(*filenames) { |f| Environment.new(f).apply! if File.exist?(f) }
  end

  # Internal: Helper to expand list of filenames.
  #
  # Returns a hash of all the loaded environment variables.
  def with(*filenames, &block)
    filenames << '.env' if filenames.empty?

    {}.tap do |hash|
      filenames.each do |filename|
        hash.merge! block.call(File.expand_path(filename)) || {}
      end
    end
  end
end
