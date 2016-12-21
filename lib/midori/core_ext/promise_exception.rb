class PromiseException < StandardError
  attr_reader :raw_exception
  def initialize(raw_exception)
    super(nil)
    @raw_exception = raw_exception
  end
end