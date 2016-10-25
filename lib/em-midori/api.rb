##
# This class provides methods to be inherited as route definition.
class Midori::API
  class << self
    # Add GET method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   get '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   get /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def get(path, &block) end

    # Add POST method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   post '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   post /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def post(path, &block) end

    # Add PUT method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   put '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   put /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def put(path, &block) end

    # Add DELETE method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   delete '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   delete /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def delete(path, &block) end

    # Add OPTIONS method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @return [ nil ] nil
    # @example String as router
    #   options '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   options /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def options(path, &block) end

    # Add LINK method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   link '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   link /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def link(path, &block) end

    # Add UNLINK method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   unlink '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   unlink /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def unlink(path, &block) end

    # Add WEBSOCKET method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   websocket '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   websocket /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def websocket(path, &block) end

    # Add EVENTSOURCE method as a DSL for route definition
    # @param [ String, Regexp ] path Accepts as part of path in route definition
    # @return [ nil ] nil
    # @example String as router
    #   eventsource '/' do
    #      puts 'Hello World'
    #   end
    #
    # @example Regex as router
    #   eventsource /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def eventsource(path, &block) end

    # Implementation of route DSL
    # @param [ String ] method HTTP method
    # @param [ String, Regexp ] path path definition
    # @param [ Proc ] block process to run when route matched
    # @return [ nil ] nil
    def add_route(method, path, block)
      if path.class == String
        # Convert String to Regexp to provide performance boost (Precompiled Regexp)
        path = convert_route path
      end
      @route = @route || []
      @route << Midori::Route.new(method, path, block)
      nil
    end

    # Process after receive data from client
    # @param request [ Midori::Request ] Http Raw Request
    # @param connection [ EM::Connection ] A connection created by EventMachine
    # @yield what to run when route matched
    # @return [ Midori::Response ] Http Response
    # @raise [ Midori::Error::NotFound ] If no route matched
    def receive(request, connection = nil)
      @route.each do |route|
        matched = match(route.method, route.path, request.method, request.path)
        next unless matched
        if @middleware.nil?
          middlewares, body_accept = [], [String]
        else
          middlewares, body_accept = @middleware.clone, @body_accept.clone
        end
        middlewares.each { |middleware| request = middleware.before(request) }
        clean_room = Midori::CleanRoom.new(request, middlewares, body_accept)
        if request.websocket?
          # Send 101 Switching Protocol
          connection.send_data Midori::Response.new(101, websocket_header(request.header['Sec-WebSocket-Key']), '')
          -> { clean_room.instance_exec(connection.websocket, *matched, &route.function) }.call
          return Midori::Response.new
        elsif request.eventsource?
          connection.send_data Midori::Response.new(200, Midori::Const::EVENTSOURCE_HEADER, '')
          -> { clean_room.instance_exec(connection.eventsource, *matched, &route.function) }.call
          return Midori::Response.new
        else
          result = -> { clean_room.instance_exec(*matched, &route.function) }.call
          clean_room.body = result if body_accept.include?(result.class)
          response = clean_room.raw_response
          middlewares.reverse_each { |middleware| response = middleware.after(request, response) }
          return response
        end
      end
      raise Midori::Error::NotFound
    end

    # Match route with given definition
    # @param [ String ] method Accepts an HTTP/1.1 method like GET POST PUT ...
    # @param [ Regexp ] path Precompiled route definition.
    # @param [ String ] request_method HTTP Request Method
    # @param [ String ] request_path HTTP Request Path
    # @return [ Array ] matched parameters
    # @return [ Boolean ] false if not matched
    # @example match a route
    #   match('GET', /^\/user\/(.*?)\/order\/(.*?)$/, '/user/foo/order/bar') # => ['foo', 'bar']
    def match(method, path, request_method, request_path)
      if request_method == method
        result = request_path.match(path)
        return result.to_a[1..-1] if result
        false
      else
        false
      end
    end

    # Convert String path to its Regexp equivalent
    # @param [ String ] path String route definition
    # @return [ Regexp ] Regexp equivalent
    # @example
    #   convert_route('/user/:id/order/:order_id') # => Regexp
    def convert_route(path)
      path = '^' + path
             .gsub(/\/(:[_a-z][_a-z0-9]+?)\//, '/([^/]+?)/')
             .gsub(/\/(:[_a-z][_a-z0-9]+?)$/, '/([^/]+?)$')
      path += '$' if path[-1] != '$'
      Regexp.new path
    end

    # Use a middleware in the all routes
    # @param [Class] middleware Inherited from +Midori::Middleware+
    # @return [nil] nil
    def use(middleware, *args)
      middleware = middleware.new(*args)
      CleanRoom.class_exec { middleware.helper }
      @middleware = [] if @middleware.nil?
      @middleware << middleware
      @body_accept = middleware.body_accept
      nil
    end

    # Return websocket header with given key
    # @param [String] key 'Sec-WebSocket-Key' in request header
    # @return [Hash] header
    def websocket_header(key)
      header = Midori::Const::WEBSOCKET_HEADER.clone
      header['Sec-WebSocket-Accept'] = Digest::SHA1.base64digest(key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')
      header
    end

    # Helper block for defining methods in APIs
    # @yield define what to run in CleanRoom
    def helper(&block)
      Midori::CleanRoom.class_exec(&block)
    end
  end

  private_class_method :add_route

  # Constants of supported methods in route definition
  METHODS = %w(get post put delete options link unlink websocket eventsource).freeze

  # Magics to fill DSL methods through dynamically class method definition
  METHODS.each do |method|
    define_singleton_method(method) do |*args, &block|
      add_route(method.upcase, args[0], block) # args[0]: path
    end
  end
end
