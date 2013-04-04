require 'dotenv/environment'

module Dotenv
  def self.load(*filenames)
    default_if_empty(filenames).inject({}) do |hash, filename|
      hash.merge(File.exists?(filename) ? Environment.new(filename).apply : {})
    end
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def self.load!(*filenames)
    load(
      *default_if_empty(filenames).each do |filename|
        raise(Errno::ENOENT.new(filename)) unless File.exists?(filename)
      end
    )
  end

protected
  def self.default_if_empty(filenames)
    filenames.empty? ? (filenames << '.env') : filenames
  end
end
