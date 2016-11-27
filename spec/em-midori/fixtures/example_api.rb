class User < Midori::API
  get '/' do
    'User'
  end
end

class ExampleAPI < Midori::API
  helper do
    define_method :test_helper do
      'Hello World'
    end
  end

  mount '/user', User
  use Midori::Middleware

  filter Midori::Middleware
  get '/' do
    return test_helper
  end

  get '/error' do
    raise StandardError
  end

  websocket '/websocket' do |ws|
    ws.on :open do
      ws.send 'Hello'
      puts 'on Open '.green
    end

    ws.on :message do |msg|
      puts 'on Message'.green
      ws.send msg
    end

    ws.on :pong do
      ws.send ''
      puts 'on Pong'.green
    end

    ws.on :close do
      puts 'on Close'.green
    end
  end

  websocket '/websocket/opcode' do |ws|
    ws.on :open do
      ws.send Object.new
    end
  end

  websocket '/websocket/ping' do |ws|
    ws.on :open do
      ws.ping ''
    end
  end

  websocket '/websocket/too_large_ping' do |ws|
    ws.on :message do
      ws.ping '01234567890123456789012345678901
      23456789012345678901234567890123456789012
      34567890123456789012345678901234567890123
      45678901234567890123456789012345678901234
      56789012345678901234567890123456789012345
      67890123456789012345678901234567890123456
      78901234567890123456789012345678901234567
      89012345678901234567890123456789012345678
      90123456789012345678901234567890123456789
      012345678901234567890123456789'
    end
  end

  websocket '/websocket/wrong_opcode' do |ws|;end

  eventsource '/eventsource' do |es|
    es.send("Hello\nWorld")
  end
end

EXAMPLE_API_ENGINE = Midori::APIEngine.new(ExampleAPI)
