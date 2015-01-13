module Hangman
  class BookKeeper
    class Room < Array
      attr_accessor :game

      def initialize
        @game = Game.new
      end

      def add(player_details)
        self << OpenStruct.new(player_details)
      end

      def players
        map(&:name)
      end
    end
  end
end
