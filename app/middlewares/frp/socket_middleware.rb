require "faye/websocket"
require "json"
require "pry"
require "recursive-open-struct"

module FRP
  class SocketMiddleware
    include SocketHTTP

    KEEPALIVE_TIME = 15

    class << self
      attr_accessor :clients
    end

    @clients = []

    def initialize(app)
      @app     = app
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do
          print "socket opened"
          SocketMiddleware.clients << ws

          ws.send RoomsController.index
        end

        ws.on :message do |event|
          p [:message, event.data]

          request     = JSON.parse(event.data)
          method      = request["headers"]["method"]
          url         = request["headers"]["url"]
          body        = RecursiveOpenStruct.new(request["body"])
          body.socket = ws

          route = SocketRouter.route(method, url)

          ws.send(route.controller.send(route.action, body))
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
