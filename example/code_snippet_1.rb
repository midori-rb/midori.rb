require 'em-midori'

class Example < Midori::API
  get '/' do
    'Hello World'
  end
end

Midori.run(Example, '127.0.0.1', 8080)