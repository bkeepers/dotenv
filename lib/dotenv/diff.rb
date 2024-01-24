module Dotenv
  # Compare two hashes and return the differences
  class Diff
    attr_reader :a, :b

    def initialize(a, b)
      @a, @b = a, b
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
  end
end
