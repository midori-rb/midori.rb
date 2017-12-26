##
# Request class for midori
# @attr [String] ip client ip address
# @attr [Integer] port client port
# @attr [String] protocol protocol version of HTTP request
# @attr [Symbol] method HTTP method
# @attr [String] path request path
# @attr [Hash] query_params parameter parsed from query string
# @attr [String | nil] query_string request query string
# @attr [Hash] header request header
# @attr [String] body request body
# @attr [Hash] cookie cookie hash coming from request
# @attr [Boolean] parsed whether the request header parsed
# @attr [Boolean] body_parsed whether the request body parsed
# @attr [Hash] params params in the url
class Midori::Request
  attr_accessor :ip, :port, :remote_ip,
                :protocol, :method, :path, :query_params, :query_string,
                :header, :body, :parsed, :body_parsed, :params, :cookie

  # Init Request
  def initialize
    @header = {}
    @parsed = false
    @body_parsed = false
    @is_websocket = false
    @is_eventsource = false
    @parser = Http::Parser.new
    @params = {}
    @query_params = Hash.new(Array.new)
    @cookie = {}
    @body = ''
    @parser.on_headers_complete = proc do
      @protocol = @parser.http_version
      @method = @parser.http_method
      @path = @parser.request_url
      @header = @parser.headers
      @remote_ip = parse_ip || @ip # Detect client real IP with RFC 7239

      @query_string = @path.match(/\?(.*?)$/)
      unless @query_string.nil?
        @query_string = @query_string[1]
        @query_params = CGI::parse(@query_string)
      end

      @cookie = CGI::Cookie.parse(@header['Cookie']) unless @header['Cookie'].nil?
      @path.gsub!(/\?(.*?)$/, '')
      @method = @method.to_sym
      @parsed = true
      :stop
    end
  end

  # Init an request with String data
  # @param [String] data
  # @return [nil] nil
  def parse(data)
    # Call parser if header not parsed
    if @parsed
      @body += data
    else
      offset = @parser << data
      @body += data[offset..-1] if @parsed
    end

    # Set body parsed if body reaches content length
    if @parsed && (@header['Content-Length'].to_i || 0) <= @body.bytesize
      @body_parsed = true
      pre_proceed
    end
    nil
  end

  def parse_ip
    client_ip = @header['X-Real-IP']
    return nil if client_ip.nil? || @header['X-Forwarded-For'].nil?
    forwarded_ips = @header['X-Forwarded-For'].split(', ')
    # If forwarded_ips doesn't include the client_ip, it might be an
    # ip spoofing attempt, so we ignore X-Real-IP
    # Other spoofing check like trust chain should be done by middleware
    return client_ip if forwarded_ips.include?(client_ip)
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
    @body_parsed
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
