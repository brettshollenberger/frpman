require "ostruct"

module Hangman
  class BookKeeper
    class Rooms < OpenStruct
      def add(room_name)
        if exists?(room_name)
          raise DuplicateRoomError, room_name
        else
          send("#{room_name}=", Room.new)
        end
      end

      def remove(room_name)
        if exists?(room_name)
          delete_field(room_name)
        end
      end

      def remove_all!
        names.each do |name|
          remove name
        end
      end

      def exists?(room_name)
        respond_to?(room_name)
      end

      def names
        methods(false).grep(/^((?!\=).)*$/s)
      end
    end
  end
end
