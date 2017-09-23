# Middlewares

Middlewares are very exciting features midori supports. As it has been implemented for lots of web frameworks. Middlewares from midori behaves very different from other frameworks, which greatly helps reducing complexity and improving performance in scaling projects.

## Basic Usage

To begin with, inheritate the `Midori::Middleware` class. Here's an example:

```ruby
class JSONMiddleware < Midori::Middleware
  def before(request)
    request.body = JSON.parse(request.body) unless request.body == ''
    request
  end

  def after(_request, response)
    response.header['Content-Type'] = 'application/json'
    response.body = response.body.to_json
    response
  end
end
```

To use middleware inside router, there're two possible ways.
One is through `use` method, which would affect all routes in the current scope.
The other is through `filter` method, which would affect the following route definition only.

Here are some examples.

```ruby
class API < Midori::API
  use AMiddleware

  filter BMiddleware
  get '/' do
    # Both AMiddleware and BMiddleware works here.
    'Hello'
  end

  get '/a' do
    # Only AMiddleware is involved here.
    'World'
  end
end
```

## Stack-less Design

For rack users, middlewares are always considered as parts of stack.
Deep stacks may cause several performance issues in Ruby, including increasing cost when context switching, thread switching and process forking, etc.
For frameworks like Rails, it defaulty contains lots of middlewares which enlarge this problem.

In midori, middlewares are no longer stack-based.
It uses a loop-based system to run middleware code.
This makes using of middlewares with less side effects.

## Early Exit Feature

Early exit feature is also supported in midori without stack.
To make it happen, just response an `Midori::Response` object in request processing.
Here's an example for CORS middleware using early exit feature.

```ruby
class CorsMiddleware < Midori::Middleware
  def before(request)
    if request.method == :OPTIONS
      # PREFLIGHT
      return Midori::Response.new(
        header: {
          'Access-Control-Allow-Origin': request.header['Origin'],
          'Access-Control-Request-Headers': 'Token',
          'Access-Control-Allow-Headers': 'Token',
          'Access-Control-Allow-Methods': 'OPTIONS, POST, PUT, DELETE'
        }
      )
    else
      request
    end
  end

  def after(request, response)
    response.header['Access-Control-Allow-Origin'] = request.header['Origin']
    response
  end
end
```
