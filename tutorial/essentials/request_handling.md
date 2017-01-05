# Request Handling

## Accessing the request object

The incoming request object can be accessed from request level (filter, routes, error handlers) through the `request` method:

```ruby
class ExampleAPI < Midori::API
  get '/' do
    request.ip           # '127.0.0.1' client ip address
    request.port         # '8080' client port
    request.method       # 'GET'
    request.path         # '/'
    request.query_string # ''
    request.header       # {} request header
    request.body         # request body sent by the client
    request.params       # {} params matched in router
  end
end
```

**Note (for sinatra users): **The `request.body` in modori is a `String` object but not a `StringIO` object.

## Construct the response object

Midori accepts the return value of the block as the response body by default.

You could edit variable `status` and `header` to construct things other than body.

You could also return a `Midori::Response` object as your response, which could override everything.

```ruby
class ExampleAPI < Midori::API
  get '/case_0' do
    'Hello'
    # HTTP/1.1 200 OK
    # Server: Midori/1.0
    #
    # Hello
  end
  
  get '/case_1' do
    status = 202
    'Hello'
    # HTTP/1.1 202 Accepted
    # Server: Midori/1.0
    #
    # Hello
  end
  
  get '/case_2' do
    header['Example-Header'] = 'Example-Value'
    'Hello'
  end
  # HTTP/1.1 200 OK
  # Server: Midori/1.0
  # Example-Header: Example-Value
  #
  # Hello
  
  get '/case_3' do
    status = 202
    header['Example-Header'] = 'Example-Value'
    Midori::Response.new(200, {}, 'Hello')
  end
  # HTTP/1.1 200 OK
  #
  # Hello
end
```

