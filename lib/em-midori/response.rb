class Midori::Response
  attr_accessor :status, :header, :body

  def initialize(code=200, header= Midori::Const::DEFAULT_HEADER, body='')
    @status = Midori::Const::STATUS_CODE[code]
    @header = header
    @body = body
  end

  def generate_header
    @header.map do |key, value|
      "#{key}: #{value}\r\n"
    end.join
  end

  def to_s
    "HTTP/1.1 #{@status}\r\n#{generate_header}\r\n#{@body}"
  end
end