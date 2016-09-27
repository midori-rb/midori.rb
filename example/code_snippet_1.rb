require 'em-midori'
require 'json'

class Example < Midori::API
  get '/' do
    'Hello World'
  end

  get '/user/:id' do |id|
    JSON.generate({
        header: @request.header,
        body: @request.body,
        id: id
                  })
  end
end

Midori.run(Example, '127.0.0.1', 8080)