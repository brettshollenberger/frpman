require_relative "../middlewares/frp/socket_http"

class GuessesController
  class << self
    include SocketHTTP
  end

  def self.create(body)
    room = Hangman::BookKeeper.rooms.send(name)
    room.game.word.guess(body.guess)

    socket_response :post, "/rooms", { room: { name: name, players: Hangman::BookKeeper.rooms.send(name).players } }
  end

private
  def self.send_rooms_to_clients
    FRP::SocketMiddleware.clients.each do |socket|
      socket.send index
    end
  end
end
