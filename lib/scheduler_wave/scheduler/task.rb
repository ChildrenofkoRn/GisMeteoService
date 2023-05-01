module SchedulerWave
  class Task
    attr_reader :thread

    # Task.new(minutes, &block)            -> task
    # Task.new(minutes,
    #         logger: nil
    #         delayed_start: false,
    #         block_args: nil,
    #         &block)                      -> task
    #
    # Creates a new task with a block that will run every N minutes.
    # The block runs in its Thread using a loop, checking every second.
    #
    # +minutes+ can be a string or a number.
    # +logger+ uses the sent logger || Logger.new(STDOUT, Logger::DEBUG)
    # +block_args+ you can pass arguments to the block.
    #
    # Normally the task is executed immediately on +run+,
    # but by specifying +delayed_start+ = true, you can delay it for a given N +minutes+.
    #
    # The object of the thread is available: task.thread
    # See Thread
    #
    def initialize(minutes:, logger: nil, delayed_start: false, block_args: nil, &block)
      @minutes = minutes.is_a?(String) ? minutes.to_i : minutes
      @logger = logger || Logger.new(STDOUT, Logger::DEBUG)
      @delayed_start = delayed_start
      @action = Action.new(block_args, &block)
      @thread = nil
    end

    def result
      @action.result
    end

    def run
      @thread = Thread.new do
        set_next_time
        sleep 3
        # if need to run immediately after creation
        @action.run unless @delayed_start

        loop do
          run_task if run?
          # check the task every one second
          sleep 1
        end
      end
    end

    def stop
      @thread.exit
    end

    # re-create if thread dead
    def restart?
      unless @thread.alive?
        stop
        run
      end
    end

    private

    def run_task
      get_debug_info
      set_next_time
      @action.run
    end

    def get_debug_info
      @logger.debug "@thread = #{@thread}"
      @logger.debug "@thread.alive? = #{@thread.alive?}"
      @logger.debug "Thread.list = \n#{Thread.list.join("\n")}"
      @logger.debug "It's time to start the task!"
      @logger.debug "Next start at #{@next_time}"
    end

    def set_next_time
      @next_time = Time.now + @minutes * 60
    end

    def run?
      Time.now.strftime('%H:%M') == @next_time.strftime('%H:%M')
    end
  end
end
