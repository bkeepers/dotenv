require 'dotenv/environment'
require 'dotenv/configuration'

module Dotenv
  def self.load(*filenames)
    default_if_empty(filenames).inject({}) do |hash, filename|
      filename = File.expand_path filename
      hash.merge(File.exists?(filename) ? Environment.new(filename).apply : {})
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

  def self.env
    @env ||= Dotenv::Configuration.new(ENV)
  end

protected
  def self.default_if_empty(filenames)
    filenames.empty? ? (filenames << '.env') : filenames
  end
end
