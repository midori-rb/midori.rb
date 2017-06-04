##
# Request class for midori
# @attr [String] ip client ip address
# @attr [Integer] port client port
# @attr [String] protocol protocol version of HTTP request
# @attr [String] method HTTP method
# @attr [String] path request path
# @attr [String] query_string request query string
# @attr [Hash] header request header
# @attr [String] body request body
# @attr [Boolean] parsed whether the request parsed
# @attr [Hash] params params in the url
class Midori::Request
  attr_accessor :ip, :port,
                :protocol, :method, :path, :query_string,
                :header, :body, :parsed, :body_parsed, :params

  # Init Request
  def initialize
    @parsed = false
    @body_parsed = false
    @is_websocket = false
    @is_eventsource = false
    @parser = Http::Parser.new
    @params = {}
    @body = ''
    @parser.on_headers_complete = proc do
      @protocol = @parser.http_version
      @method = @parser.http_method
      @path = @parser.request_url
      @header = @parser.headers

      @query_string = @path.match(/\?(.*?)$/)
      @query_string = @query_string[1] unless @query_string.nil?
      @path.gsub!(/\?(.*?)$/, '')
      @method = @method.to_sym
      @body += data[offset..-1]
      @parsed = true
      :stop
    end
  end

  # Init an request with String data
  # @param [String] data
  # @return [nil] nil
  def parse(data)
    # Call parser if header not parsed
    @parsed ? @body += data : offset = @parser << data

    # Set body parsed if body reaches content length
    if (@header['Content-Length'].to_i || 0) == @body.bytesize
      @body_parsed = true
      pre_proceed
    end
    nil
  end

  # Preproceed the request after parsed
  # @return [nil] nil
  def pre_proceed
    # Deal with WebSocket
    if @header['Upgrade'] == 'websocket' && @header['Connection'] == 'Upgrade'
      @method = :WEBSOCKET
      @is_websocket = true
    end

    # Deal with EventSource
    if @header['Accept'] == 'text/event-stream'
      @method = :EVENTSOURCE
      @is_eventsource = true
    end

    @method = @method.to_sym
    nil
  end

  # Syntactic sugar for whether a request header is parsed
  # @return [Boolean] parsed or not
  def parsed?
    @parsed
  end

  # Syntactic sugar for whether a request body is parsed
  # @return [Boolean] parsed or not
  def body_parsed?
    @body_parsed?
  end

  # Syntactic sugar for whether a request is a websocket request
  # @return [Boolean] websocket or not
  def websocket?
    @is_websocket
  end

  # Syntactic sugar for whether a request is an eventsource request
  # @return [Boolean] eventsource or not
  def eventsource?
    @is_eventsource
  end
end
