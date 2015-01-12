require_relative "../middlewares/frp/socket_http"

class SessionsController
  class << self
    include SocketHTTP
  end

  def self.create(body)
    session = { :name => body.name, :socket => body.socket }
    room = Hangman::BookKeeper.rooms.send(body.room)

    room.add(session)

    notify_room_of_new_player(room, body)

    socket_response :post, "/sessions", { :session => { :name => body.name, :room => body.room } }
  end

private
  def self.notify_room_of_new_player(room, body)
    room.select do |player|
      player.name != body.name
    end.each do |player|
      player.socket.send RoomsController.show OpenStruct.new({:name => body.room})
    end
  end
end
