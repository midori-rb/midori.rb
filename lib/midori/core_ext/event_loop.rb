module EventLoop
  class << self
    SELECTOR = NIO::Selector.new
    @stop = true

    def register(io, interest=(:rw), &callback)
      monitor = SELECTOR.register(io, interest)
      monitor.value = callback
    end

    def change(monitor, interest=(:rw), &callback)
      monitor.interests = interest
      monitor.value = callback
    end

    def unregister(io)
      SELECTOR.deregister(io)
    end

    def run_once
      SELECTOR.select(10) do |monitor| # Timeout for 10 secs
        monitor.value.call(monitor)
      end
    end

    def start
      @stop = false
      loop do
        run_once
        break if @stop
      end
    end

    def stop
      @stop = true
    end

    def running?
      !@stop
    end
  end
end
