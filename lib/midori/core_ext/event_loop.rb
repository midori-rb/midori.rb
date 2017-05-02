##
# EventLoop Module, providing main loop for events
module EventLoop
  class << self
    # Raw NIO Selector
    SELECTOR = NIO::Selector.new
    # Array of active timers
    TIMERS = []
    # Hash of io and its callback
    IOS = Hash.new
    # IO queue
    QUEUE = Hash.new

    # Add timer in event loop
    # @param [EventLoop::Timer] timer timer to insert
    # @return [nil] nil
    def add_timer(timer)
      timer.start_time = Time.now.to_f + timer.time
      TIMERS << timer
      nil
    end

    # Register I/O event with queue protection
    # @param [IO] io io to register
    # @param [Symbol] interest :r for read only, :w for write only, and :rw for both
    # @yield what to run when io callbacks
    # @return [nil] nil
    def register(io, interest=(:rw), &callback)
      if QUEUE[io.to_i].nil?
        QUEUE[io.to_i] = Array.new
        register_raw(io, interest, callback)
      else
        QUEUE[io.to_i] << [io, interest, callback]
      end
      nil
    end

    # Register I/O event directly, without any queue protection
    # @param [IO] io io to register
    # @param [Symbol] interest :r for read only, :w for write only, and :rw for both
    # @param [Proc] callback what to run when io callbacks
    # @return [nil] nil
    def register_raw(io, interest=(:rw), callback)
      SELECTOR.register(io, interest)
      IOS[io] = { callback: callback }
      nil
    end

    # Deregister I/O event
    # @param [IO] io io to deregister
    # @return [nil] nil
    def deregister(io)
      fd = io.to_i
      SELECTOR.deregister(io)
      IOS.delete(io)
      next_register = QUEUE[fd].shift
      next_register.nil? ? QUEUE.delete(fd) : register_raw(*next_register)
      nil
    end

    # Run I/O selector once
    # @return [nil] nil
    def run_once
      SELECTOR.select(0.2) do |monitor| # Timeout for 0.2 secs
        IOS[monitor.io][:callback].call(monitor)
      end
      EventLoop.timer_once
      nil
    end

    # Run timer once
    # @return [nil] nil
    def timer_once
      now_time = Time.now.to_f
      TIMERS.delete_if do |timer|
        if timer.start_time < now_time
          timer.callback.call
          true
        end
      end
      nil
    end

    # Start the event loop
    # @return [nil] nil
    def start
      return if running?
      @stop = false
      until @stop
        run_once
      end
      @stop = nil
    end

    # Set the stop flag
    # @return [nil] nil
    def stop
      @stop = true
      nil
    end

    # Detect the stop flag
    # @return [Boolean] return if eventloop is set to be stopped
    def running?
      @stop = true if @stop.nil?
      !@stop
    end
  end
end
