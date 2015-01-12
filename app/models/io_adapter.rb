module Hangman
  class IOAdapter
    attr_accessor :socket

    def initialize(socket)
      @socket = socket
    end

    def write(msg)
      socket.puts(msg)
    end
  end
end
