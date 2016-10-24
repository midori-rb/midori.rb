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
                :header, :body, :parsed

  # Init Request
  def initialize
    @parsed = false
    @is_websocket = false
    @is_eventsource = false
  end

  # Init an request with StringIO data
  # @param [StringIO+] data Request data
  def parse(data)
    @header = {}

    # Parse request
    line = data.gets.split
    @protocol = line[2]
    @method = line[0]
    @query_string = line[1].match(/\?(.*?)$/)
    @query_string = @query_string[1] unless @query_string.nil?
    @path = line[1].gsub(/\?(.*?)$/, '')

    # Parse header
    while (line = data.gets) != "\r\n"
      line = line.split
      @header[line[0][0..-2]] = line[1..-1].join(' ')
    end

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

    # Parse body
    @body = data.read
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
