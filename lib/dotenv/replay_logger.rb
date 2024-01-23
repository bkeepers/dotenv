module Dotenv
  # A logger that can be used before the apps real logger is initialized.
  class ReplayLogger
    def initialize
      @logs = []
    end

    def method_missing(name, *args, &block)
      @logs.push([name, args, block])
    end

    def respond_to_missing?(name, include_private = false)
      (include_private ? Logger.instance_methods : Logger.public_instance_methods).include?(name) || super
    end

    def replay(logger)
      @logs.each { |name, args, block| logger.send(name, *args, &block) }
    end
  end
end
