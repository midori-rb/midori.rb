##
# This module store errors to be handled inside Midori
module Midori::Exception
  # No route matched
  class NotFound < StandardError; end
  # Internal Error
  class InternalError < StandardError; end
  # Midori doesn't support continuous frame of WebSockets yet
  class ContinuousFrame < StandardError; end
  # WebSocket OpCode not defined in RFC standards
  class OpCodeError < StandardError; end
  # Websocket request not masked
  class NotMasked < StandardError; end
  # Websocket frame has ended
  class FrameEnd < StandardError; end
  # Websocket Ping Pong size too large
  class PingPongSizeTooLarge < StandardError; end
  # Not sending String in EventSource
  class EventSourceTypeError < StandardError; end
  # Insert a not middleware class to middleware list
  class MiddlewareError < StandardError; end
end
