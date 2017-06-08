# Routing

## Basic Usage

Routes should be defined inside a class inherited from `Midori::API`. Midori doesn't support defining routes globally like sinatra to avoid scope pollution, which affects a lot in scaling project.

In midori, a route is an HTTP method with a URL-matching pattern. Each route is associated with a block:

```ruby
class ExampleAPI < Midori::API
  get '/' do
    #.. show something ..
  end
  
  post '/' do
    #.. create something ..
  end
  
  put '/' do
    #.. replace something ..
  end
  
  delete '/' do
    #.. annihilate something ..
  end
  
  options '/' do
    #.. appease something ..
  end
  
  link '/' do
    #.. affiliate something ..
  end
  
  unlink '/' do
    #.. separate something ..
  end
end
```

Routes are matched in the order they are defined. The first route that matches the request is invoked.

Midori not only supports the methods above, it supports almost every method provided in RFC standards. You could look it up in [API doc](http://www.rubydoc.info/gems/em-midori/Midori/API) for more details.

## Params

Routes patterns may include named parameters, accessible via the `request.params` hash:

```ruby
class ExampleAPI < Midori::API
  get '/hello/:name' do
    "Ohayou #{request.params['name']}"
  end
end
```

Route patterns may also include splat (or wildcard) parameters, accessible via the `request.params['splat']` array:

```ruby
class ExampleAPI < Midori::API
  get '/say/*/to/*' do
    # matches /say/hello/to/world
    request.params['splat'] # => ["hello", "world"]
  end

  get '/download/*.*' do
    # matches /download/path/to/file.xml
    request.params['splat'] # => ["path/to/file", "xml"]
  end
end
```

Routes may also utilize query string:

```ruby
class ExampleAPI < Midori::API
  get '/posts' do
    # matches "GET /posts?title=foo&author=bar"
    request.query_string # => title=foo&author=bar
  end
end
```

## WebSocket & EventSource

`WebSocket` connection uses `GET` method in HTTP protocol, but indeed, it behaves totally different from `GET` requests. You don't need to care about the protocol details. In midori, you could easily manage websocket connections easily.

Here's a chatroom example using websocket in midori:

```ruby
CONNECTION_POOL = []

class ExampleAPI < Midori::API
  websocket '/' do |ws|
    ws.on :open do
      ws.send 'Ohayo Midori'
      CONNECTION_POOL << ws
    end
    
    ws.on :message do |msg|
      CONNECTION_POOL.map do |client|
        client.send msg
      end
    end
    
    ws.on :close do
      CONNECTION_POOL.delete(ws)
      puts 'Oyasumi midori'
    end
  end
end
```

midori also supports `EventSource` connection as part of your route.

Here's a chatroom example using eventsource in midori:

```ruby
CONNECTION_POOL = []

class ExampleAPI < Midori::API
  post '/pub' do
    clients = CONNECTION_POOL.clone
    CONNECTION_POOL.clear
    # EventSource connection disconnects every time message sent, DO NOT reuse connection pool
    clients.map do |client|
      client.send request.body
    end
  end
  
  eventsource '/sub' do |es|
    CONNECTION_POOL << es
  end
end
```

