require "spec_helper"

describe Hangman::Runner do
  before(:each) do
    @bretts_connection = StringIO.new
    @shaloms_connection = StringIO.new

    Hangman::BookKeeper.add_room(:my_great_game)

    Hangman::BookKeeper.add_player(:my_great_game, {:name => "Brett", :socket => @bretts_connection})
    Hangman::BookKeeper.add_player(:my_great_game, {:name => "Shalom", :socket => @shaloms_connection})
  end

  it "writes to connections" do
    Hangman::Runner.write(:brett, "Hello")

    @bretts_connection.rewind

    expect(@bretts_connection.gets.chomp).to eq "Hello"
  end
end
