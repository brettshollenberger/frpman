require_relative "../middlewares/frp/socket_http"

class RoomsController
  class << self
    include SocketHTTP
    attr_accessor :rooms
  end

  @rooms = {:shaloms_room => "cool"}

  def self.index(body="")
    socket_response :get, "/rooms", { rooms: RoomsController.rooms.keys }
  end

  def self.create(body)
    name = body.name.gsub(/\s/) { |space| "_" }.downcase
    @rooms[name] = []
    socket_response :post, "/rooms", [ room: @rooms[name] ]
  end
end
