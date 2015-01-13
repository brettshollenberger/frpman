require "spec_helper"

describe Hangman::BookKeeper do
  before(:each) do
    Hangman::BookKeeper.empty!
  end

  it "adds new rooms" do
    Hangman::BookKeeper.add_room(:shaloms_room)

    expect(Hangman::BookKeeper.rooms.names).to include(:shaloms_room)
  end

  it "adds games when a room is added" do
    Hangman::BookKeeper.add_room(:shaloms_room)

    expect(Hangman::BookKeeper.rooms.shaloms_room.game.word.length).to be > 0
  end

  it "does not add duplicate rooms" do
    Hangman::BookKeeper.add_room(:shaloms_room)

    expect { Hangman::BookKeeper.add_room(:shaloms_room) }.to raise_error Hangman::BookKeeper::DuplicateRoomError
    expect { Hangman::BookKeeper.add_room(:bretts_room)  }.to_not raise_error
  end

  it "adds players to rooms" do
    Hangman::BookKeeper.add_room(:shaloms_room)
    Hangman::BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

    expect(Hangman::BookKeeper.rooms.shaloms_room.players).to include("brett")
  end

  it "does not add duplicate player names" do
    Hangman::BookKeeper.add_room(:shaloms_room)
    Hangman::BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

    expect { Hangman::BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}}) }.to raise_error Hangman::BookKeeper::DuplicatePlayerError
  end

  it "removes players" do
    Hangman::BookKeeper.add_room(:shaloms_room)
    Hangman::BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

    Hangman::BookKeeper.remove_player(:brett)

    expect(Hangman::BookKeeper.connections.exists?(:brett)).to be false
    expect(Hangman::BookKeeper.rooms.shaloms_room.players).to_not include(:brett)
  end

  it "removes rooms & all players from rooms" do
    Hangman::BookKeeper.add_room(:shaloms_room)
    Hangman::BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

    Hangman::BookKeeper.remove_room(:shaloms_room)

    expect(Hangman::BookKeeper.rooms.exists?(:shaloms_room)).to be false
    expect(Hangman::BookKeeper.connections.exists?(:brett)).to be false
  end

  describe Hangman::BookKeeper::Rooms do
    it "adds new rooms" do
      Hangman::BookKeeper.rooms.add(:shaloms_room)

      expect(Hangman::BookKeeper.rooms.shaloms_room).to eq([])
    end

    it "knows whether or not it has a certain room" do
      Hangman::BookKeeper.rooms.add(:shaloms_room)

      expect(Hangman::BookKeeper.rooms.exists?(:shaloms_room)).to be true
      expect(Hangman::BookKeeper.rooms.exists?(:bretts_room)).to be false
    end
  end

  describe Hangman::BookKeeper::Room do
    it "adds players" do
      Hangman::BookKeeper.rooms.add(:shaloms_room)
      Hangman::BookKeeper.rooms.shaloms_room.add(:name => :brett, :socket => {})

      expect(Hangman::BookKeeper.rooms.shaloms_room.players).to eq([:brett])
    end
  end
end
