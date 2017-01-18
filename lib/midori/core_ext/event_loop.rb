module EventLoop
  class << self
    SELECTOR = NIO::Selector.new
    @stop = true

    def register(io, interest=(:rw), &callback)
      monitor = SELECTOR.register(io, interest)
      monitor.value = callback
    end

    def unregister(io)
      SELECTOR.deregister(io)
    end

    def run_once
      SELECTOR.select do |monitor|
        monitor.value.call(monitor)
      end
    end

    def start
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
