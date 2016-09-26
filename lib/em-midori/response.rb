class Midori::Response
  attr_accessor :status, :header, :body

  def initialize(code=200, header={}, body='')
    @status = Midori::Const::STATUS_CODE[code]
    @header = header
    @body = body
  end

  def to_s
    "HTTP/1.1 #{@status}\r\nServer: Midori/#{Midori::VERSION}\r\n\r\n#{@body}"
  end
end