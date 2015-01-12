module Hangman
  class Runner
    class << self
      def write(connection, msg)
        connections.send(connection).socket.write(msg)
      end

    private
      def connections
        BookKeeper.connections
      end
    end
  end
end
