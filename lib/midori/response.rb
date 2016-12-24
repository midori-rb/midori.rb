##
# Class for midori response
# @attr [String] status HTTP response status
# @attr [Hash] header HTTP response header
# @attr [String] body HTTP response body
class Midori::Response
  attr_accessor :status, :header, :body

  # @param [Fixnum] code HTTP response code
  # @param [Hash] header HTTP response header
  # @param [String] body HTTP response body
  # Init a Response
  def initialize(code = 200, header = Midori::Const::DEFAULT_HEADER.clone, body = '')
    @status = Midori::Const::STATUS_CODE[code]
    @header = header
    @body = body
  end

  # Generate header string from hash
  # @return [String] generated string
  def generate_header
    @header.map do |key, value|
      "#{key}: #{value}\r\n"
    end.join
  end

  # Convert response to raw string
  # @return [String] generated string
  def to_s
    "HTTP/1.1 #{@status}\r\n#{generate_header}\r\n#{@body}"
  end
end
