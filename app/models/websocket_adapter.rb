module Hangman
  class WebsocketAdapater
    attr_accessor :socket

    def initialize(socket)
      @socket = socket
    end

    def write(msg)
      socket.send(msg)
    end
  end
end
