require_relative "../middlewares/frp/socket_http"

class HangmanController
  class << self
    include SocketHTTP
  end

  def self.show(body)
    room = Hangman::BookKeeper.rooms.send(body.room_name)

    socket_response :get, "/hangman/:room_name", {
      room: {
        name: body.room_name
      },
      hangman: room.game.man
    }
  end
end
