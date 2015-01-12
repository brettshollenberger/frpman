module Hangman
  class Dictionary
    class << self
      attr_accessor :words

      def sample
        words.sample.downcase
      end
    end

    @words = File.read("/usr/share/dict/words").split("\n")
  end
end
