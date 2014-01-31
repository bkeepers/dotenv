require 'dotenv/environment'
require 'yaml'

module Dotenv
  def self.load(*filenames)
    default_if_empty(filenames).inject({}) do |hash, filename|
      filename = File.expand_path filename
      hash.merge(File.exists?(filename) ? Environment.new(filename).apply : {})
    end
  end

  # same as `load`, but will override existing values in `ENV`
  def self.overload(*filenames)
    default_if_empty(filenames).inject({}) do |hash, filename|
      filename = File.expand_path filename
      hash.merge(File.exists?(filename) ? Environment.new(filename).apply! : {})
    end
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def self.load!(*filenames)
    load(
      *default_if_empty(filenames).each do |filename|
        filename = File.expand_path filename
        raise(Errno::ENOENT.new(filename)) unless File.exists?(filename)
      end
    )
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
  def self.default_if_empty(filenames)
    filenames.empty? ? (filenames << '.env') : filenames
  end
end
