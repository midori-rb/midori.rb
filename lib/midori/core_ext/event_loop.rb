require 'timeout'

##
# EventLoop Module, providing main loop for events
module EventLoop
  class << self
    SELECTOR = NIO::Selector.new
    TIMERS = []
    IOS = Hash.new
    QUEUE = Hash.new

    def add_timer(timer)
      timer.start_time = Time.now.to_f + timer.time
      TIMERS << timer
    end

    def register(io, interest=(:rw), &callback)
      if QUEUE[io.to_i].nil?
        QUEUE[io.to_i] = Array.new
        register_raw(io, interest, callback)
      else
        QUEUE[io.to_i] << [io, interest, callback]
      end
    end

    def register_raw(io, interest=(:rw), callback)
      SELECTOR.register(io, interest)
      IOS[io] = { callback: callback }
    end

    def deregister(io)
      fd = io.to_i
      SELECTOR.deregister(io)
      IOS.delete(io)
      next_register = QUEUE[fd].shift
      next_register.nil? ? QUEUE.delete(fd) : register_raw(*next_register)
    end

    def run_once
      SELECTOR.select(0.2) do |monitor| # Timeout for 0.2 secs
        IOS[monitor.io][:callback].call(monitor)
      end
      EventLoop.timer_once
    end

    def timer_once
      now_time = Time.now.to_f
      TIMERS.delete_if do |timer|
        if timer.start_time < now_time
          timer.callback.call
          true
        end
      end
    end

    def start
      return if running?
      @stop = false
      until @stop
        run_once
      end
      @stop = nil
    end

    def stop
      @stop = true
    end

    def running?
      @stop = true if @stop.nil?
      !@stop
    end
  end
end
