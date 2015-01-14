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

  def self.update(body)
    room = Hangman::BookKeeper.rooms.send(body.name)

    if body.game && body.game.started
      room.game.start!
    end

    notify_game_updated(room)

    socket_response :put, "/rooms/:name", { room: { name: room.name }, game: { started: room.game.started? } }
  end

private
  def self.send_rooms_to_clients
    FRP::SocketMiddleware.clients.each do |socket|
      socket.send index
    end
  end

  def self.notify_game_updated(room)
    room.each do |player|
      player.socket.send socket_response :put, "/rooms/:name", {
        room: {
          name: room.name
        },
        game: {
          started: room.game.started?
        }
      }

      player.socket.send controller_action NotificationsController, "show", {
        room_name: room.name,
        game: room.game,
        player: player.name,
        notification: :game_started
      }
    end
  end
end
