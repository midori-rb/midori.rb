require '../lib/em-midori'
require 'json'

class Example < Midori::API
  get '/' do
    'Hello World'
  end

  get '/user/dump' do |id|
    JSON.generate({
        header: @request.header,
        body: @request.body,
        id: id
                  })
  end

  get '/user/login' do
    define_error :forbidden_request, :unauthorized_error
    begin
      request = JSON.parse(@body)
      UserController.login(request['username'], request['password'])
      # => {code: 0, token: String}
    rescue ForbiddenRequest => _e
      Midori::Response.new(403, {code: 403, message: 'Illegal request'}.to_json)
    rescue UnauthorizedError => _e
      Midori::Response.new(401, {code: 401, message: 'Incorrect username or password'}.to_json)
    rescue => _e
      Midori::Response.new(400, {code: 400, message: 'Bad Request'}.to_json)
    end
  end

  get '/user/:id/profile' do |id|
    define_error :forbidden_request, :unauthorized_error
    begin
      protected!(id)
      UserController.get_profile(id)
      # => {username: String, avatar: String}
    rescue ForbiddenRequest => _e
      Midori::Response.new(403, {code: 403, message: 'Illegal request'}.to_json)
    rescue UnauthorizedError => _e
      Midori::Response.new(401, {code: 401, message: 'Token incorrect'}.to_json)
    rescue => _e
      Midori::Response.new(400, {code: 400, message: 'Bad Request'}.to_json)
    end
  end

end

Midori.run(Example, '127.0.0.1', 8080)
