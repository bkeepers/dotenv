require 'dotenv/environment'

module Dotenv
  def self.load(*filenames)
    filenames << '.env' if filenames.empty?
    filenames.inject({}) do |hash, filename|
      hash.merge Dotenv::Environment.new(filename).apply
    end
  end
end

require 'dotenv/railtie' if defined?(Rails) and defined?(Rails::Railtie)
