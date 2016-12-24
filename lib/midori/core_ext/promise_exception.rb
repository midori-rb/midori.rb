##
# A special error as containers of errors inside [ Promise ]
# @attr [ StandardError ] raw_exception raw execption raised
class PromiseException < StandardError
  attr_reader :raw_exception

  # Init PromiseException
  # @param [ StandardError ] raw_exception raw execption raised
  def initialize(raw_exception)
    super(nil)
    @raw_exception = raw_exception
  end
end
