module Midori::Error
  class NotFound < StandardError; end
  class ContinuousFrame < StandardError; end
  class OpCodeError < StandardError; end
  class NotMasked < StandardError; end
  class FrameEnd < StandardError; end
end
