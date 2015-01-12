module Hangman
  class BookKeeper
    class Connections < OpenStruct
      def exists?(player_name)
        respond_to?(player_name)
      end

      def remove_all!
        all.each do |name|
          remove name
        end
      end

      def remove(player_name)
        if exists?(player_name)
          delete_field(player_name)
        end
      end

      def all
        methods(false).grep(/^((?!\=).)*$/s)
      end
    end
  end
end
