require 'dotenv/parser'
require 'dotenv/environment'

module Dotenv
  def self.load(*filenames)
    with(*filenames) { |f| Environment.new(f).apply if File.exist?(f) }
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def self.load!(*filenames)
    with(*filenames) { |f| Environment.new(f).apply }
  end

  # same as `load`, but will override existing values in `ENV`
  def self.overload(*filenames)
    with(*filenames) { |f| Environment.new(f).apply! if File.exist?(f) }
  end

  # Internal: Helper to expand list of filenames.
  #
  # Returns a hash of all the loaded environment variables.
  def self.with(*filenames, &block)
    filenames << '.env' if filenames.empty?

    {}.tap do |hash|
      filenames.each do |filename|
        hash.merge! block.call(File.expand_path(filename)) || {}
      end
    end
  end
end
