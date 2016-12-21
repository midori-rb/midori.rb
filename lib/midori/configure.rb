##
# Default configuration of Midori, extends +Configurable+
class Midori::Configure
  extend Configurable

  set :logger, ::Logger.new(STDOUT)
  set :bind, '127.0.0.1'
  set :port, 8080
  set :route_type, :sinatra
  set :before, proc {}
end
