# Getting Started

## Hello Midori

midori is a [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) for web and API development in Ruby  with minimal effort:

```ruby
# hello_midori.rb
require 'midori'

class HelloWorldAPI < Midori::API
  get '/' do
    'Ohayou Midori'
  end
end

Midori::Runner.new(HelloWorldAPI).start
```

Run with

```
$ ruby hello_midori.rb
```

View at: http://127.0.0.1:8080 with your browser, if you see a page showing: **Ohayou Midori**. You've made your first application with midori.

