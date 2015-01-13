module Hangman
  class Game
    class OutOfTurnGuessError < StandardError; end
    class NotAPlayerError < StandardError; end
    class PreviouslyGuessedError < StandardError; end

    attr_accessor :word, :players, :current_player, :runner, :messages,
                  :guesses, :current_error, :winner, :man, :hangman_pieces

    def self.hangman_pieces
      ["hat", "head", "body", "left_arm", "right_arm", "left_leg", "right_leg"]
    end

    def initialize(options={})
      @word           = Hangman::Word.new(options)
      @players        = Hangman::Game::Players.new
      @turn_number    = 0
      @guesses        = []
      @man            = []
      @hangman_pieces = Game.hangman_pieces.dup
    end

    def current_player
      players[turn_number]
    end

    def guess(guesser, letter_guessed)
      protect_invalid_guesses(guesser, letter_guessed)

      answer_correct = word.guess(letter_guessed)
      guesses.push(letter_guessed)
      select_winner if over?
      hang_man unless answer_correct
      switch_turn

      return answer_correct
    end

    def over?
      word.solved? || man_hung?
    end

    def select_winner
      @winner = current_player
    end

  private
    def man_hung?
      man == Game.hangman_pieces
    end

    def protect_invalid_guesses(guesser, letter_guessed)
      guesser_number = player_number(guesser)

      if guesser_number.nil?
        raise NotAPlayerError, guesser
      elsif turn_number != guesser_number
        raise OutOfTurnGuessError, guesser
      elsif guesses.include?(letter_guessed)
        raise PreviouslyGuessedError, letter_guessed
      end
    end

    def turn_number
      @turn_number
    end

    def turn_number=(n)
      @turn_number = n
    end

    def player_number(player_name)
      if player_name.respond_to?(:to_s)
        players.each.with_index.reduce(nil) do |selected_player_index, (player, index)|
          return selected_player_index unless selected_player_index.nil?
          return index if player.name == player_name.to_s
        end
      end
    end

    def switch_turn
      @turn_number += 1

      if current_player.nil?
        @turn_number = 0
      end
    end

    def hang_man
      man.push(hangman_pieces.shift)
    end
  end
end
