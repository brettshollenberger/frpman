module Hangman
  class BookKeeper
    class Room < Array
      def add(player_details)
        self << OpenStruct.new(player_details)
      end

      def players
        map(&:name)
      end
    end
  end
end
