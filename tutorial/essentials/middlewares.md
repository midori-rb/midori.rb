# Middlewares

Middlewares are very exciting features midori supports. As it has been implemented for lots of web frameworks. Middlewares from midori behaves very different from other frameworks, which greatly helps reducing complexity and improving performance in scaling projects.

## Basic Usage

To begin with, inheritate the `Midori::Middleware` class. Here's an example:

```ruby
class JSONMiddleware < Middleware
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



## Stack-less Design

## Early Exit Feature

