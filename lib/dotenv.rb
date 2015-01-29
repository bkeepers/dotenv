require 'dotenv/parser'
require 'dotenv/environment'

module Dotenv
  extend self

  attr_accessor :instrumenter

  def process(filename, optional, override)

    # determine filename, return if not found and optional
    if !File.exist?(filename)
      if ENV.key?("DOTENVCRYPT") && File.exist?(dotenvcrypt = "#{filename}.crypt")
        filename = dotenvcrypt
      elsif optional
        return
      end
    end

    # load environment as requested, with optional decryption
    env = Environment.new(filename)
    instrument('dotenv.load', :env => env) { override ? env.apply! : env.apply }
  end

  def load     *filenames; with(*filenames) {|f| process(f, true , false) }; end
  def load!    *filenames; with(*filenames) {|f| process(f, false, false) }; end
  def overload *filenames; with(*filenames) {|f| process(f, true , true ) }; end

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

  def instrument(name, payload = {}, &block)
    if instrumenter
      instrumenter.instrument(name, payload, &block)
    else
      block.call
    end
  end
end
