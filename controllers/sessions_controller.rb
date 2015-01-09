require_relative "../middlewares/frp/socket_http"

class SessionsController
  class << self
    include SocketHTTP
  end

  def self.create(body)
    session = { :name => body.name, :socket => body.socket }
    room = RoomsController.rooms[body.room]

    room.push(session)

    socket_response :post, "/sessions", { :session => { :name => body.name, :room => body.room } }
  end
end
