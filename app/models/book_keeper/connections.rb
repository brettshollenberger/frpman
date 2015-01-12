module Hangman
  class BookKeeper
    class Connections < OpenStruct
      def exists?(player_name)
        respond_to?(player_name)
      end

      def remove_all!
        names.each do |name|
          remove name
        end
      end

      def remove(player_name)
        if exists?(player_name)
          delete_field(player_name)
        end
      end

      def names
        methods(false).grep(/^((?!\=).)*$/s)
      end

      def each(&block)
        names.map do |name|
          send(name)
        end.each(&block)
      end
    end
  end
end
