require_relative "../middlewares/frp/socket_http"

class GuessesController
  class << self
    include SocketHTTP
  end

  def self.index(body)
    room = Hangman::BookKeeper.rooms.send(body.room_name)

    socket_response :get, "/guesses/:room_name", {
      room: {
        name: body.room_name
      },
      guesses: room.game.guesses
    }
  end

  def self.create(body)
    room    = Hangman::BookKeeper.rooms.send(body.roomName)
    game    = room.game
    guesser = body.guesser
    guess   = body.guess

    begin
      result = game.guess(guesser, guess)
      notify_word(room)
      notify_guesses(room)
    rescue => e
    end

    socket_response :post, "/guesses/:room_name", {}
  end

private
  def self.notify_word(room)
    each_connection(room) do |sock|
      sock.send controller_action WordsController, "show", {room_name: room.name}
    end
  end

  def self.notify_guesses(room)
    each_connection(room) do |sock|
      sock.send controller_action GuessesController, "index", {room_name: room.name}
    end
  end
end
