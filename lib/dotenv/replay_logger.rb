module Dotenv
  # A logger that can be used before the apps real logger is initialized.
  class ReplayLogger < Logger
    def initialize
      super(StringIO.new) # Doesn't matter what we log to, we're not going to use it.
      @logs = []
    end

    # Override the add method to store logs so we can replay them to a real logger later.
    def add(*args, &block)
      @logs.push([args, block])
    end

    # Replay the store logs to a real logger.
    def replay(logger)
      @logs.each { |args, block| logger.add(*args, &block) }
      @logs.clear
    end
  end
end
