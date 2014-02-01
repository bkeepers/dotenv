require 'dotenv'
module Dotenv
  class Generator
    attr_reader :environment, :example_file, :target_file

    def [](key)
      values[key.to_s]
    end
    alias_method :get, :[]

    def []=(key, value)
      values[key.to_s] = value
    end
    alias_method :set, :[]=

    def existing
      Dotenv.parse *[".env.#{@environment}", @target_file]
    end

    def examples
      Dotenv.parse @example_file
    end
    
    def values(reset=false)
      @values = nil if reset
      @values ||= Hash[*examples.merge(existing).map { |k,v| [k, existing[k]] }.flatten]
    end

    def prompt_for(key)
      print_key_prompt key
      input = STDIN.gets.chomp
      input.empty? ? values[key] : input
    end

    def prompt
      values.keys.each { |key| values[key] = prompt_for(key) }
    end

    def write
      File.open(@target_file, 'w') { |f| f.write to_s }
    end

    def to_s
      values.map { |k,v| "#{k}=#{v}" }.join($/)
    end

    protected

    def initialize(environment=nil, example_file=nil, target_file=nil)
      @environment = environment.to_s
      @example_file = File.expand_path(example_file || '.env.example')
      @target_file = File.expand_path(target_file || ".env.#{@environment}")
      @target_file = File.expand_path('.env') if target_file.nil? && environment.nil?
    end

    def longest_key
      values.keys.max { |k| k.length }
    end

    def print_key_prompt(key)
      STDOUT.puts $/
      STDOUT.puts  "#{key.rjust longest_key.length} - #{examples[key] || 'No example or description provided'}"
      STDOUT.puts  "#{" " * longest_key.length}   Enter a new value for #{key} or use the existing value"
      STDOUT.print "#{" " * longest_key.length}   (#{values[key].to_s.empty? ? 'no value' : values[key].to_s}): "
    end
  end
end
