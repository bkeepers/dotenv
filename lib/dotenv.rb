require 'dotenv/environment'

module Dotenv
  def self.load(*filenames)
    filenames << '.env' if filenames.empty?
    filenames.inject({}) do |hash, filename|
      hash.update Environment.new(filename).apply if File.exists?(filename)
      hash
    end
  end
end
