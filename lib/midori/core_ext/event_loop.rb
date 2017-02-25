require 'timeout'

module EventLoop
  class << self
    SELECTOR = NIO::Selector.new
    TIMERS = []

    def add_timer(timer)
      timer.start_time = Time.now.to_f + timer.time
      TIMERS << timer
    end

    def remove_timer(timer)
      TIMERS.delete(timer)
    end

    def register(io, interest=(:rw), &callback)
      monitor = SELECTOR.register(io, interest)
      monitor.value = {
          callback: callback,
      }

    end

    def deregister(io)
      SELECTOR.deregister(io)
    end

    def run_once
      SELECTOR.select(0.2) do |monitor| # Timeout for 1 secs
        monitor.value[:timer].stop unless monitor.value[:timer].nil?
        monitor.value[:callback].call(monitor)
      end
      EventLoop.timer_once
    end

    def timer_once
      now_time = Time.now.to_f
      TIMERS.delete_if do |timer|
        if timer # A serious bug may cause timer to be "false" on ruby 2.3.3
          if timer.start_time < now_time
            timer.callback.call
            true
          end
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
