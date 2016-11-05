class APIEngine
  attr_accessor :routes
  def initialize(root_api, type = :sinatra)
    @routes = {
      GET: [],
      POST: [],
      PUT: [],
      DELETE: [],
      OPTIONS: [],
      LINK: [],
      UNLINK: [],
      WEBSOCKET: [],
      EVENTSOURCE: [],
      MOUNT: []
    }
    @root_api = root_api
    @type = type
    merge(root_api, type)
  end

  def merge(root_api, type)
    # Merge all routes with a Depth-first search
    @routes.merge(root_api.routes) do |key, old_val, new_val|
      
    end
  end

  # Process after receive data from client
  # @param request [ Midori::Request ] Http Raw Request
  # @param connection [ EM::Connection ] A connection created by EventMachine
  # @return [ Midori::Response ] Http Response
  # @raise [ Midori::Error::NotFound ] If no route matched
  def receive(request, connection = nil)
    @routes[request.method].each do |route|
      params = route.params(request.path)
      next unless params
      request.params = params
      route.middlewares.each { |middleware| request = middleware.before(request) }
      clean_room = Midori::CleanRoom.new(request, route.body_accept)
      if request.websocket?
        # Send 101 Switching Protocol
        connection.send_data Midori::Response.new(101, websocket_header(request.header['Sec-WebSocket-Key']), '')
        -> { clean_room.instance_exec(connection.websocket, &route.function) }.call
        return Midori::Response.new
      elsif request.eventsource?
        connection.send_data Midori::Response.new(200, Midori::Const::EVENTSOURCE_HEADER, '')
        -> { clean_room.instance_exec(connection.eventsource, &route.function) }.call
        return Midori::Response.new
      else
        result -> { clean_room.instance_exec(&route.function) }
        clean_room.body = result if route.body_accept.include?(result.class)
        response = clean_room.raw_response
        route.middlewares.reverse_each { |middleware| response = middleware.after(request, response) }
        return response
      end
    end
    raise Midori::Error::NotFound
  end

  # Return websocket header with given key
  # @param [String] key 'Sec-WebSocket-Key' in request header
  # @return [Hash] header
  def self.websocket_header(key)
    header = Midori::Const::WEBSOCKET_HEADER.clone
    header['Sec-WebSocket-Accept'] = Digest::SHA1.base64digest(key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')
    header
  end

end
