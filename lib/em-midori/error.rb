module Midori::Error
  class NotFound < StandardError; end
  class ContinuousFrame < StandardError; end
  class OpCodeError < StandardError; end
  class NotMasked < StandardError; end
  class FrameEnd < StandardError; end
  class PingPongSizeTooLarge < StandardError; end
  class EventSourceTypeError < StandardError; end
  class MiddlewareError < StandardError; end
end
