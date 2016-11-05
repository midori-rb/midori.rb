##
# Request class for midori
# @attr [String] ip client ip address
# @attr [Fixnum] port client port
# @attr [String] protocol protocol version of HTTP request
# @attr [String] path request path
# @attr [String] query_string request query string
# @attr [Hash] header request header
# @attr [String] body request body
# @attr [Boolean] parsed whether the request parsed
class Midori::Request
  attr_accessor :ip, :port,
                :protocol, :method, :path, :query_string,
                :header, :body, :parsed, :params

  # Init Request
  def initialize
    @parsed = false
    @is_websocket = false
    @is_eventsource = false
    @parser = Http::Parser.new
    @params = {}
    @parser.on_headers_complete = proc do
      @protocol = @parser.http_version
      @method = @parser.http_method
      @path = @parser.request_url
      @header = @parser.headers
      :stop
    end
  end

  # Init an request with StringIO data
  def parse(data)

    offset = @parser << data
    @body = data[offset..-1]
    @query_string = @path.match(/\?(.*?)$/)
    @query_string = @query_string[1] unless @query_string.nil?
    @path.gsub!(/\?(.*?)$/, '')

    # Deal with WebSocket
    if @header['Upgrade'] == 'websocket' && @header['Connection'] == 'Upgrade'
      @method = 'WEBSOCKET'
      @is_websocket = true
    end

    # Deal with EventSource
    if @header['Accept'] == 'text/event-stream'
      @method = 'EVENTSOURCE'
      @is_eventsource = true
    end

    @method = @method.to_sym
    @parsed = true
  end

  # Syntatic sugur for whether a request is parsed
  # @return [Boolean] parsed or not
  def parsed?
    @parsed
  end

  # Syntatic sugur for whether a request is a websocket request
  # @return [Boolean] websocket or not
  def websocket?
    @is_websocket
  end

  # Syntatic sugur for whether a request is an eventsource request
  # @return [Boolean] eventsource or not
  def eventsource?
    @is_eventsource
  end
end
