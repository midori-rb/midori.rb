class Midori::Test
  def initialize(api)

  end

  def request(method, path, header = {}, body)

  end

  def websocket(path)
    Midori::Test::Websocket.new(api, path)
  end
end

class Modri::Test::Websocket
end

class Midori::Test::EventSource
end
