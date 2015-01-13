require "spec_helper"

describe Hangman::Game do
  let(:game) { Hangman::Game.new(secret: "fun") }

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

  it "adds players" do
    game.players << {name: "brett"}
    expect(game.players.map(&:name)).to include "brett"
  end

  describe "Playing a game" do
    before(:each) do
      %w(Brett Shalom).each do |name|
        game.players << {name: name}
      end
    end

    it "reports whose turn it is" do
      expect(game.current_player.name).to eq "Brett"
    end

    it "allows the current player to guess a letter" do
      expect(game.guess("Brett", "e")).to be false
    end

    it "does not allow another player to guess a letter" do
      expect { game.guess("Shalom", "e") }.to raise_error Hangman::Game::OutOfTurnGuessError
    end

    it "does not allow a non-player to guess a letter" do
      expect { game.guess("Jake", "e") }.to raise_error Hangman::Game::NotAPlayerError
    end

    it "does not allow invalid guesses" do
      expect { game.guess("Brett", "fun") }.to raise_error Hangman::Word::InvalidGuessError
    end

    it "does not switch turns when errors are raised" do
      begin
        game.guess("Brett", "fun")
      rescue
      end

      expect(game.current_player.name).to eq "Brett"
    end

    it "tracks guessed letters" do
      game.guess("Brett", "f")
      game.guess("Shalom", "r")

      expect(game.guesses).to include "f"
      expect(game.guesses).to include "r"
      expect(game.guesses).to_not include "u"
    end

    it "does not allow previously guessed letters" do
      game.guess("Brett", "f")
      expect { game.guess("Shalom", "f") }.to raise_error Hangman::Game::PreviouslyGuessedError
    end

    it "correctly reports the word after guessing" do
      game.guess("Brett", "f")
      expect(game.word).to eq "f--"
    end

    it "switches turns after guessing" do
      game.guess("Brett", "f")
      expect(game.current_player.name).to eq "Shalom"

      game.guess("Shalom", "u")
      expect(game.current_player.name).to eq "Brett"
    end

    it "adds pieces to the hung man as incorrect guesses are made" do
      game.guess("Brett", "q")
      expect(game.man).to eq ["hat"]

      game.guess("Shalom", "w")
      expect(game.man).to eq ["hat", "head"]

      game.guess("Brett", "e")
      expect(game.man).to eq ["hat", "head", "body"]

      game.guess("Shalom", "t")
      expect(game.man).to eq ["hat", "head", "body", "left_arm"]

      game.guess("Brett", "y")
      expect(game.man).to eq ["hat", "head", "body", "left_arm", "right_arm"]

      game.guess("Shalom", "i")
      expect(game.man).to eq ["hat", "head", "body", "left_arm", "right_arm", "left_leg"]

      game.guess("Brett", "o")
      expect(game.man).to eq ["hat", "head", "body", "left_arm", "right_arm", "left_leg", "right_leg"]
    end

    it "is over when the man is completely hung" do
      game.man = ["hat", "head", "body", "left_arm", "right_arm", "left_leg", "right_leg"]

      expect(game.over?).to be true
    end

    it "does not allow guesses when the game is over" do
      game.give_up!

      expect(game.over?).to be true

      expect { game.guess("Brett", "o") }.to raise_error Hangman::Game::GameOverError
    end

    it "selects a winner when the game is over" do
      game.guess("Brett", "f")
      game.guess("Shalom", "u")
      game.guess("Brett", "n")

      expect(game.winner.name).to eq "Brett"
    end
  end
end
