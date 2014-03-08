require 'dotenv/parser'
require 'dotenv/environment'

module Dotenv
  def self.load(*filenames)
    with(*filenames) { |f| Environment.new(f).apply if File.exists?(f) }
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def self.load!(*filenames)
    with(*filenames) { |f| Environment.new(f).apply }
  end

  # same as `load`, but will override existing values in `ENV`
  def self.overload(*filenames)
    with(*filenames) { |f| Environment.new(f).apply! if File.exists?(f) }
  end
  
  # same as `load`, but will not apply to ENV
  def self.parse(*filenames)
    default_if_empty(filenames).inject({}) do |hash, filename|
      filename = File.expand_path filename
      hash.merge(File.exists?(filename) ? Environment.new(filename) : {})
    end
  end
  
  # same as `parse`, but raises Errno::ENOENT if any files don't exist
  def self.parse!(*filenames)
    parse(
      *default_if_empty(filenames).each do |filename|
        filename = File.expand_path filename
        raise(Errno::ENOENT.new(filename)) unless File.exists?(filename)
      end
    )
  end

protected

  def self.with(*filenames, &block)
    filenames << '.env' if filenames.empty?

    filenames.inject({}) do |hash, filename|
      filename = File.expand_path filename
      hash.merge(block.call(filename) || {})
    end
  end
end
