require_relative "../middlewares/frp/socket_http"

class RoomsController
  class << self
    include SocketHTTP
    attr_accessor :rooms
  end

  @rooms = {}

  def self.index(body="")
    socket_response :get, "/rooms", { rooms: RoomsController.rooms.keys }
  end

  def self.show(body)
    players = @rooms[body.name].map { |player| player[:name] }
    socket_response :get, "/rooms/:name", { room: { name: body.name, players: players } }
  end

  def self.create(body)
    name = body.name.gsub(/\s/) { |space| "_" }.downcase
    @rooms[name] = []

    send_rooms_to_clients

    socket_response :post, "/rooms", { room: { name: name, players: @rooms[name] } }
  end

private
  def self.send_rooms_to_clients
    FRP::SocketMiddleware.clients.each do |socket|
      socket.send index
    end
  end
end
