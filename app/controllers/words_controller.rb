require_relative "../middlewares/frp/socket_http"

class WordsController
  class << self
    include SocketHTTP
  end

  def self.show(body)
    room = Hangman::BookKeeper.rooms.send(body.room_name)
    socket_response :get, "/words/:room_name", { room_name: body.room_name, word: room.game.word }
  end
end
