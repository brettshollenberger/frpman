require_relative "../middlewares/frp/socket_http"

class RoomsController
  class << self
    include SocketHTTP
  end

  def self.index(body="")
    socket_response :get, "/rooms", { rooms: Hangman::BookKeeper.rooms.names }
  end

  def self.show(body)
    players = Hangman::BookKeeper.rooms.send(body.name).players
    socket_response :get, "/rooms/:name", { room: { name: body.name, players: players } }
  end

  def self.create(body)
    name = body.name.gsub(/\s/) { |space| "_" }.downcase
    Hangman::BookKeeper.add_room(name)

    send_rooms_to_clients

    socket_response :post, "/rooms", { room: { name: name, players: Hangman::BookKeeper.rooms.send(name).players } }
  end

private
  def self.send_rooms_to_clients
    FRP::SocketMiddleware.clients.each do |socket|
      socket.send index
    end
  end
end
