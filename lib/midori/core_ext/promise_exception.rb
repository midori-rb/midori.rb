##
# A special error as containers of errors inside [ Promise ]
# @attr [ StandardError ] raw_exeption raw execption raised
class PromiseException < StandardError
  attr_reader :raw_exception
  def initialize(raw_exception)
    super(nil)
    @raw_exception = raw_exception
  end
end
