require 'em-midori'

class API < Midori::API
  get '/' do
    'Hello World'
  end
end

Midori.run(API, '127.0.0.1', 4564)
