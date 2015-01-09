require_relative "../middlewares/frp/socket_http"

class SessionsController
  class << self
    include SocketHTTP
  end

  def self.create(body)
    session = { :name => body.name, :socket => body.socket }
    room = RoomsController.rooms[body.room]

    room.push(session)

    room.select do |player|
      player[:name] != body.name
    end.each do |player|
      player[:socket].send RoomsController.show OpenStruct.new({:name => body.room})
    end

    socket_response :post, "/sessions", { :session => { :name => body.name, :room => body.room } }
  end
end
