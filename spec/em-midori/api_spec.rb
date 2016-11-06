require './spec/spec_helper'
require 'json'

include Midori

class RawHello < API
  use Middleware
  get '/' do
    'Hello'
  end
  post '/' do; end
  put '/' do; end
  delete '/' do; end
  options '/' do; end
  link '/' do; end
  unlink '/' do; end
  websocket '/' do; end
  eventsource '/' do; end
end

class JSONMiddleware < Middleware
  def before(request)
    request.body = JSON.parse(request.body) unless request.body == ''
    request
  end

  def after(_request, response)
    response.header['Content-Type'] = 'application/json'
    response.body = response.body.to_json
    response
  end

  def body_accept
    [Hash, Array]
  end
end

class JSONHello < Midori::API
  use Middleware
  get '/' do
    use JSONMiddleware
    {code: 0}
  end
end

