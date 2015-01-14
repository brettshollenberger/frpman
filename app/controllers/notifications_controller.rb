require_relative "../middlewares/frp/socket_http"

class NotificationsController
  class << self
    include SocketHTTP
  end

  def self.show(body)
    socket_response :get, "/notifications/:room_name", send(body.notification, body)
  end

private
  def self.letter_guessed(body)
    guesser = body.guesser == body.player ? "You" : body.guesser

    {
      :room => {
        :name => body.room_name
      },
      :player => body.player,
      :notification => {
        :title => "Letter Guessed",
        :message => letter_guessed_text(guesser, body.guess),
        :type => "info"
      }
    }
  end

  def self.error(body)
    err_method = error_name(body.error)

    {
      :room => {
        :name => body.room_name
      },
      :player => body.player,
      :notification => {
        :title => "Error",
        :message => send(err_method, body),
        :type => "danger"
      }
    }
  end

  def self.error_name(error)
    error
      .class
      .to_s
      .gsub(/\w*\:\:/) {}
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase + "_text"
  end

  def self.letter_guessed_text(guesser, guess)
    "#{guesser} guessed #{guess}"
  end

  def self.previously_guessed_error_text(body)
    "#{body.guess} has already been guessed"
  end

  def self.out_of_turn_guess_error_text(body)
    "It is #{body.game.current_player.name}'s turn."
  end
end
