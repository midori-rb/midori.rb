require 'sinatra'
require 'thin'

configure do
  set :server, ['thin']
  set :port, 4567
end

get '/' do
  'Hello World'
end
