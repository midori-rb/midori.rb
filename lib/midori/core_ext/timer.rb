##
# Timer Object in EventLoop
class EventLoop::Timer
  # @!attribute [r] time
  #   @return [Float] timeout length
  # @!attribute [r] callback
  #   @return [Proc] proc to call when callbacks
  attr_reader :time, :callback
  # @!attribute start_time
  #   @return [Float] when timer should callbacks
  attr_accessor :start_time

  # @param [Float] time timeout length
  # @yield proc to call when callbacks
  def initialize(time, &callback)
    @time = time
    @callback = callback
    @start_time = Float::INFINITY
  end
end
