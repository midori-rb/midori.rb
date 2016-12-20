class Midori::Test
  def initialize(api)

  end

  def request(method, path, header = {}, body)

  end

  def websocket(path, header = {})
    Midori::Test::Websocket.new(api, path, header)
  end

  def evetsource(path, header = {}, body)
    Midori::Test::EventSource.new(api, path, header, body)
  end
end

class Modri::Test::Websocket
end

class Midori::Test::EventSource
end
