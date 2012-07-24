require 'dotenv/environment'

module Dotenv
  def self.load(filename = '.env')
    Dotenv::Environment.new(filename).apply
  end
end

require 'dotenv/railtie' if defined?(Rails)
