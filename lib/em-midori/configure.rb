require_relative 'core_ext/configurable'
require 'logger'

class Midori::Configure
  extend Midori::Configurable

  set :logger, ::Logger.new(STDOUT)
  set :bind, '127.0.0.1'
  set :port, 8080
end
