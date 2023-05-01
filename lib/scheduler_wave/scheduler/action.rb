module SchedulerWave
  class Action
    attr_reader :result

    def initialize(block_args, &block)
      @block_args = block_args
      @block = block
      @result = nil
    end

    def run
      @result = @block.call(@block_args)
    end
  end
end
