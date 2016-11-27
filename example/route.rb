#!/usr/bin/env ruby -I ../lib -I lib
require 'em-midori'
require 'json'
require_relative 'controllers/user_controller'

define_error :forbidden_request, :unauthorized_error
class Example < Midori::API
  get '/' do
    'Hello World'
  end

  get '/user/:id/dump' do
    { header: request.header,
      body: request.body,
      id: request.params['id'] }.to_json
  end

  websocket '/websocket/:id' do |ws|
    ws.on :open do
      puts 'on Open'.green
      puts request.params['id']
      ws.send request.params['id']
    end

    ws.on :message do |msg|
      puts 'on Message'.green
      ws.send msg
    end

    ws.on :close do
      puts 'on Close'.green
    end
  end

  capture ForbiddenRequest do |_e|
    Midori::Response.new(403, {code: 403, message: 'Illegal request'}.to_json)
  end

  capture UnauthorizedError do |_e|
    Midori::Response.new(401, {code: 401, message: 'Incorrect username or password'}.to_json)
  end

  get '/user/login' do
    request = JSON.parse(request.body)
    Midori::Response.new(200, UserController.login(request['username'], request['password']).to_json)
    # => {code: 0, token: String}
  end

  get '/user/:id/profile' do |id|
    begin
      protected!(id)
      UserController.get_profile(id)
      # => {username: String, avatar: String}
    rescue 'ForbiddenRequest' => _e
      Midori::Response.new(403, {code: 403, message: 'Illegal request'}.to_json)
    rescue 'UnauthorizedError' => _e
      Midori::Response.new(401, {code: 401, message: 'Token incorrect'}.to_json)
    rescue => _e
      Midori::Response.new(400, {code: 400, message: 'Bad Request'}.to_json)
    end
  end

end

Midori::Runner.new(Example).start
