#!/usr/bin/env ruby -I ../lib -I lib
require 'em-midori'
require 'json'
require_relative 'controllers/user_controller'

class Example < Midori::API
  get '/' do
    'Hello World'
  end

  get '/user/:id/dump' do |id|
    { header: @request.header,
      body: @request.body,
      id: id }.to_json
  end

  websocket '/websocket/:id' do |ws, id|
    ws.on :open do
      puts 'on Open'.green
      ws.send id
    end

    ws.on :message do |msg|
      puts 'on Message'.green
      ws.send msg
    end

    ws.on :close do
      puts 'on Close'.green
    end
  end

  get '/user/login' do
    define_error :forbidden_request, :unauthorized_error
    begin
      request = JSON.parse(@request.body)
      Midori::Response.new(200, UserController.login(request['username'], request['password']).to_json)
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
