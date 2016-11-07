##
# This class is used to be sandbox of requests processing.
# @attr [Fixnum] code HTTP response code
# @attr [Hash] header HTTP response header
# @attr [Object] body HTTP response body. String could is accepted by default, but could leave for further process with +Midori::Middleware+
# @attr [Midori::Request] request HTTP request
class Midori::CleanRoom
  attr_accessor :code, :header, :body, :request
  # @param [Midori::Request] request HTTP request
  def initialize(request)
    @status = 200
    @header = Midori::Const::DEFAULT_HEADER.clone
    @body = ''
    @request = request
  end

  # Generate response from variables inside +Midori::CleanRoom+
  # @return [Midori::Response] midori response
  def raw_response
    Midori::Response.new(@status, @header, @body)
  end
end
