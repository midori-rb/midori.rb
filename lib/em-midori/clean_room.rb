##
# This class is used to be sandbox of requests processing.
# @attr [Fixnum] code HTTP response code
# @attr [Hash] header HTTP response header
# @attr [Object] body HTTP response body. String could is accepted by default, but could leave for further process with +Midori::Midlleware+
# @attr [Midori::Request] request HTTP request
class Midori::CleanRoom
  attr_accessor :code, :header, :body, :request
  # @param [Midori::Request] request HTTP request
  # @param [Array<Midori::Middleware>] middleware middlewares to run
  # @param [Array<Class>] body_accept what class for body could last middleware accept by default
  def initialize(request, body_accept = [String])
    @status = 200
    @header = Midori::Const::DEFAULT_HEADER.clone
    @body = ''
    @request = request
    @body_accept = body_accept
  end

  # Genenrate response from variables inside +Midori::CleanRoom+
  # @return [Midori::Response] midori response
  def raw_response
    Midori::Response.new(@status, @header, @body)
  end
end
