# Runner

## Introdution

`Runner` is the container of midori server. You could create, start, stop midori instance by `Runner`.

`Runner` use `Midori::Configure` as its configuration by default.

## Examples

Here're some examples for common usages

### Port Binding

Start midori instance with port `4567` instead of the default `8080`.

```ruby
require 'midori'
class API < Midori::API
  get '/' do
    'Hello World'
  end
end

Midori::Configure.set :port, 4567
Midori::Runner.new(API).start
```

### Address Binding

Start midori instance listening to all IP addresses.

```ruby
require 'midori'
class API < Midori::API
  get '/' do
    'Hello World'
  end
end

Midori::Configure.set :bind, '0.0.0.0'
Midori::Runner.new(API).start
```

### Stop Midori

Stop midori instance when specified route been called.

```ruby
require 'midori'
$runner = nil
class API < Midori::API
  get '/stop' do
    $runner.stop
  end
end

$runner = Midori::Runner.new(API).start
```
