module Hangman
  class Game
    class Player
      attr_accessor :name

      def initialize(options={})
        @name = options[:name]
      end
    end
  end
end
