module Hangman
  class BookKeeper
    class Room < Array
      attr_accessor :game, :name

      def initialize(room_name)
        @game = Game.new
        @name = room_name
      end

      def add(player_details)
        self << OpenStruct.new(player_details)
        game.players << player_details
      end

      def players
        map(&:name)
      end
    end
  end
end
