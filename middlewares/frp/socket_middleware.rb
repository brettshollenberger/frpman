require "faye/websocket"
require "json"

module FRP
  class SocketMiddleware
    include SocketHTTP

    KEEPALIVE_TIME = 15

    def initialize(app)
      @app     = app
      @clients = []
      @rooms   = {:shaloms_room => []}
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do
          print "socket opened"
          @clients << ws

          ws.send socket_response :get, "/rooms", @rooms.keys
        end

        ws.on :message do |event|
          p [:message, event.data]
        end

        ws.on :close do |event|
          p [:close]
          @clients.delete(ws)
        end

        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
