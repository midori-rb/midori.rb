class ExampleConfigure < Midori::Configure
  set :logger, Logger.new(StringIO.new)
  set :bind, '127.0.0.1'
  set :port, 8080
end
