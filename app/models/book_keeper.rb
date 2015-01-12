require "ostruct"
require "redis"
require "json"
require_relative "./runner"

module Hangman
  class BookKeeper
    class DuplicateRoomError < StandardError; end
    class DuplicatePlayerError < StandardError; end

    class << self
      attr_accessor :rooms, :connections, :runner
    end

    @rooms       = Rooms.new
    @connections = Connections.new
    @runner      = Runner.new

    def self.empty!
      rooms.remove_all!
      connections.remove_all!
    end

    def self.add_room(room_name)
      rooms.add(room_name)
    end

    def self.add_player(room_name, player_details)
      player_details = OpenStruct.new(player_details.merge(:room => room_name))

      if connections.exists?(player_details.name)
        raise DuplicatePlayerError, player_details
      else
        rooms.send(room_name).add(player_details)
        connections.send("#{player_details.name}=", player_details)
      end
    end

    def self.remove_player(player_name)
      rooms.send(connections.send(player_name).room).delete_if { |player| player.name == player_name }
      connections.remove(player_name)
    end

    def self.remove_room(room_name)
      if rooms.exists?(room_name)
        rooms.send(room_name).map(&:name).each { |player| connections.remove(player) }
        rooms.remove(room_name)
      end
    end
  end
end
