class WrappedEnv
  class << self
    def [](key)
      overrides.key?(key) ? overrides[key] : ENV[key]
    end

    def fetch(key, &block)
      return overrides[key] if overrides.key?(key)
      ENV.fetch(key, &block)
    end

    def cast(key)
      normalize(self[key])
    end

    def cast!(key, &block)
      normalize(fetch(key, &block))
    end

    def override(hash)
      hash.each_pair do |key, val|
        overrides[key] = val
      end
    end

    def reset
      overrides.clear
    end

    private

    def normalize(val)
      case
      when val === 'true'  then true
      when val === 'false' then false
      when val === ''      then nil
      when try_int(val)    then val.to_i
      when try_float(val)  then val.to_f
      else val
      end
    end

    def try_int(val)
      Integer(val)
    rescue ArgumentError
      nil
    end

    def try_float(val)
      Float(val)
    rescue ArgumentError
      nil
    end

    def overrides
      @overrides ||= {}
    end
  end
end
