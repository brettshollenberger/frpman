module Hangman
  class SocketAdapter
    def self.adapt(socket)
      case socket.class
      when Faye::WebSocket
        WebsocketAdapter.new(socket)
      else
        IOAdapter.new(socket)
      end
    end
  end
end
