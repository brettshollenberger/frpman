require "spec_helper"

describe BookKeeper do
  before(:each) do
    BookKeeper.remove_room(:shaloms_room)
    BookKeeper.remove_room(:bretts_room)
  end

  it "adds new rooms", :focus do
    BookKeeper.add_room(:shaloms_room)

    expect(BookKeeper.rooms.names).to include("shaloms_room")
  end

#   it "does not add duplicate rooms" do
#     BookKeeper.add_room(:shaloms_room)

#     expect { BookKeeper.add_room(:shaloms_room) }.to raise_error BookKeeper::DuplicateRoomError
#     expect { BookKeeper.add_room(:bretts_room)  }.to_not raise_error
#   end

#   it "adds players to rooms" do
#     BookKeeper.add_room(:shaloms_room)
#     BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

#     expect(BookKeeper.rooms.shaloms_room.players).to include(:brett)
#   end

#   it "does not add duplicate player names" do
#     BookKeeper.add_room(:shaloms_room)
#     BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

#     expect { BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}}) }.to raise_error BookKeeper::DuplicatePlayerError
#   end

#   it "tracks which connections exist" do
#     BookKeeper.add_room(:shaloms_room)
#     BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

#     expect(BookKeeper.connections.brett.socket).to eq({})
#   end

#   it "removes players" do
#     BookKeeper.add_room(:shaloms_room)
#     BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

#     BookKeeper.remove_player(:brett)

#     expect(BookKeeper.connections.exists?(:brett)).to be false
#     expect(BookKeeper.rooms.shaloms_room.players).to_not include(:brett)
#   end

#   it "removes rooms & all players from rooms" do
#     BookKeeper.add_room(:shaloms_room)
#     BookKeeper.add_player(:shaloms_room, {:name => :brett, :socket => {}})

#     BookKeeper.remove_room(:shaloms_room)

#     expect(BookKeeper.rooms.exists?(:shaloms_room)).to be false
#     expect(BookKeeper.connections.exists?(:brett)).to be false
#   end

#   describe "Notifications" do
#   end

#   describe BookKeeper::Rooms do
#     it "adds new rooms" do
#       BookKeeper.rooms.add(:shaloms_room)

#       expect(BookKeeper.rooms.shaloms_room).to eq([])
#     end

#     it "knows whether or not it has a certain room" do
#       BookKeeper.rooms.add(:shaloms_room)

#       expect(BookKeeper.rooms.exists?(:shaloms_room)).to be true
#       expect(BookKeeper.rooms.exists?(:bretts_room)).to be false
#     end
#   end

#   describe BookKeeper::Room do
#     it "adds players" do
#       BookKeeper.rooms.add(:shaloms_room)
#       BookKeeper.rooms.shaloms_room.add(:name => :brett, :socket => {})

#       expect(BookKeeper.rooms.shaloms_room.players).to eq([:brett])
#     end
#   end
end
