class EventLoop::Timer
  attr_reader :time, :start_time, :callback
  attr_accessor :start_time

  def initialize(time, &callback)
    @time = time
    @callback = callback
    @start_time = Float::INFINITY
  end

  def stop
    EventLoop.remove_timer(self)
  end
end