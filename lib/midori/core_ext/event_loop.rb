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
        if timer.start_time < now_time
          timer.callback.call
          timer.stop
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

class EventLoop::Timer
  attr_reader :time, :start_time, :callback
  attr_accessor :start_time

  def initialize(time, &callback)
    @time = time
    @callback = callback
  end

  def stop
    EventLoop.remove_timer(self)
  end
end