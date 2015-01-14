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
    next_player = body.game.current_player.name
    turn_name = next_player == body.player ? "your" : "#{next_player}'s"

    {
      :room => {
        :name => body.room_name
      },
      :player => body.player,
      :notification => {
        :title => "Letter Guessed",
        :message => letter_guessed_text(guesser, body.guess, turn_name),
        :type => "info"
      }
    }
  end

  def self.game_started(body)
    {
      :room => {
        :name => body.room_name
      },
      :notification => {
        :title => "Game Started",
        :message => game_started_text(body),
        :type => "info"
      }
    }
  end

  def self.player_joined(body)
    {
      :room => {
        :name => body.room_name
      },
      :player => body.player.name,
      :notification => {
        :title => "Player Joined",
        :message => player_joined_text(body.joined),
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

  def self.game_started_text(body)
    current_player = body.game.current_player.name
    player         = body.player == current_player ? "your" : "#{current_player}'s"

    "It's #{player} turn"
  end

  def self.game_not_started_error_text(body)
    "The game is not yet started. Start the game to guess a letter."
  end

  def self.letter_guessed_text(guesser, guess, turn_name)
    "#{guesser} guessed #{guess}. It's #{turn_name} turn."
  end

  def self.player_joined_text(player)
    "#{player} joined the game"
  end

  def self.previously_guessed_error_text(body)
    "#{body.guess} has already been guessed"
  end

  def self.out_of_turn_guess_error_text(body)
    "It is #{body.game.current_player.name}'s turn."
  end

  def self.game_over_error_text(body)
    "The game is over. You can no longer make guesses."
  end
end
