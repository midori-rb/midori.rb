##
# Default configuration of Midori, extends +Configurable+
class Midori::Configure
  extend Configurable

  set :logger, ::Logger.new(STDOUT)
  set :bind, '127.0.0.1'
  set :port, 8080
  set :route_type, :sinatra
  set :before, proc {}
  set :proxy, false
  set :trust_real_ip, false
  set :trusted_proxies, /\A127\.0\.0\.1\Z|\A(10|172\.(1[6-9]|2[0-9]|30|31)|192\.168)\.|
                         \A::1\Z|\Afd[0-9a-f]{2}:.+|\Alocalhost\Z|\Aunix\Z|\Aunix:/ix
  set :tcp_fast_open, true
  set :socket_reuse_port, false
  set :keep_alive, true
  set :keep_alive_timeout, 75
  set :keep_alive_requests, 1000
end
