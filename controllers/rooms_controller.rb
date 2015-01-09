require_relative "../middlewares/frp/socket_http"

class RoomsController
  class << self
    include SocketHTTP
    attr_accessor :rooms
  end

  @rooms = {:shaloms_room => "cool"}

  def self.index(body)
    socket_response :get, "/rooms", RoomsController.rooms.keys
  end
end
