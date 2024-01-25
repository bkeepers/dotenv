module Dotenv
  # A diff between multiple states of ENV.
  class Diff
    attr_reader :a

    # Create a new diff. The initial state defaults to a clone of current ENV. If given a block,
    # the state of ENV will be preserved as the final state for comparison. Otherwise, the current
    # ENV will be the current state.
    def initialize(a: current_env, b: nil, &block)
      @a, @b = a, b
      if block
        begin
          block.call self
        ensure
          @b = current_env
        end
      end
    end

    def b
      @b || current_env
    end

    def current_env
      ENV.to_h.freeze
    end

    # Return a Hash of keys added with their new values
    def added
      @added ||= b.slice(*(b.keys - a.keys))
    end

    # Returns a Hash of keys removed with their previous values
    def removed
      @removed ||= a.slice(*(a.keys - b.keys))
    end

    # Returns of Hash of keys changed with an array of their previous and new values
    def changed
      @changed ||= (b.slice(*a.keys).to_a - a.to_a).map do |(k, v)|
        [k, [a[k], v]]
      end.to_h
    end

    # Returns a Hash of all added, changed, and removed keys and their new values
    def env
      @env ||= b.slice(*(added.keys + changed.keys)).merge(removed.transform_values { |v| nil })
    end

    def any?
      [added, removed, changed].any?(&:any?)
    end
  end
end
