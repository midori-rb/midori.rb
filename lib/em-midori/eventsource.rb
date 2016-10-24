##
# This class provides methods for EventSource connection instance.
# @attr [EM::Connection] connection the connection instance of EventMachine
class Midori::EventSource
  attr_accessor :connection

  # @param [EM::Connection] connection the connection instance of EventMachine
  def initialize(connection)
    @connection = connection
  end

  # Send data and close the connection
  # @param [String] data data to be sent
  def send(data)
    raise Midori::Error::EventSourceTypeError unless data.is_a?String
    @connection.send_data(data.split("\n").map {|str| "data: #{str}\n"}.join + "\n")
    @connection.close_connection_after_writing
  end
end
