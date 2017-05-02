##
# Timer Object in EventLoop
# @!attribute [r] time
#   @return [Float] timeout length
# @!attribute [r] callback
#   @return [Proc] proc to call when callbacks
# @!attribute start_time
#   @return [Float] when timer should callbacks
class EventLoop::Timer

  attr_reader :time, :callback
  attr_accessor :start_time

  # Init a timer with a time period and callback
  # @param [Float] time timeout length
  # @yield proc to call when callbacks
  def initialize(time, &callback)
    @time = time
    @callback = callback
    @start_time = Float::INFINITY
  end
end
