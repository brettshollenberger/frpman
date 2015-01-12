require "spec_helper"

describe Hangman::Game do
  let(:game) { Hangman::Game.new(secret: "fun") }

  before(:each) do
  end

  it "loads in a word" do
    expect(game.word.secret).to eq "fun"
  end

  it "is not over when the word is not solved" do
    expect(game.over?).to be false
  end

  it "is over when it is solved" do
    game.word.guess "f"
    game.word.guess "u"
    game.word.guess "n"

    expect(game.over?).to be true
  end
end
