class Midori::Response
  attr_accessor :status_code, :header, :body

  def initialize(code=200, header={}, body='')
    @status_code = Midori::Const::STATUS_CODE[code]
    @header = header
    @body = body
  end

  def to_s
    "HTTP/1.1 #{@status_code}\r\nServer: Midori/#{Midori::VERSION}\r\n\r\n#{@body}"
  end
end