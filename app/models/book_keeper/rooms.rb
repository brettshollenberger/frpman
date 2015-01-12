require "redis"
require "json"

module Hangman
  class BookKeeper
    class Rooms
      attr_accessor :redis

      def initialize
        @redis = Redis.new
      end

      def add(room_name)
        if exists?(room_name)
          raise DuplicateRoomError, room_name
        else
          redis.hset("room", room_name, "[]")
        end
      end

      def remove(room_name)
        redis.hdel("room", room_name)
      end

      def exists?(room_name)
        !!redis.hget("room", room_name)
      end

      def names
        redis.hkeys("room")
      end

      private
      def room_key(room_name)
        "room #{room_name}"
      end
    end
  end
end
