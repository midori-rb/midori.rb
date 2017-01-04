# Routing

## Basic Usage

Routes should be defined inside a class inherited from `Midori::API`. Midori doesn't support defining routes  globally like sinatra to avoid scope pollution, which affects a lot in scaling project.

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

