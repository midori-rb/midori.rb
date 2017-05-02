##
# Timer Object in EventLoop
class EventLoop::Timer
  # @!attribute time
  #   @return [Float] timeout length
  # @!attribute callback
  #   @return [Proc] proc to call when callbacks
  # @!attribute start_time
  #   @return [Float] when timer should callbacks
  attr_reader :time, :callback
  attr_accessor :start_time

  # @param [Float] time timeout length
  # @yield proc to call when callbacks
  def initialize(time, &callback)
    @time = time
    @callback = callback
    @start_time = Float::INFINITY
  end
end
