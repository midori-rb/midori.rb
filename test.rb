require './lib/midori'

class API < Midori::API
  get '/' do
    'Hello'
  end
end

Midori::Runner.new(API).start
