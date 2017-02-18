module EventLoop
  class << self
    SELECTOR = NIO::Selector.new

    def register(io, interest=(:rw), &callback)
      monitor = SELECTOR.register(io, interest)
      monitor.value = callback
    end

    def unregister(io)
      SELECTOR.deregister(io)
    end

    def run_once
      SELECTOR.select(1) do |monitor| # Timeout for 1 secs
        monitor.value.call(monitor)
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
