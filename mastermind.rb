# frozen_string_literal: true

##
# This class represents the Mastermind game.
class Mastermind
  VALID_CODES = %w[A B C D E F].freeze
  CODE_LENGTH = 4
  NUMBER_OF_ATTEMPTS = 8

  def initialize
    new_game
  end

  def new_game
    # TODO: Need to implement
  end

  def play?(choice)
    # TODO: Need to implement

    true
  end

  def check_winner?
    # TODO: Need to implement
  end

  def more_choices_remaining?
    # TODO: Need to implement
  end

  def print_game
    # TODO: Need to implement
  end

  private

  def random_code
    # TODO: Need to implement
  end

  def attempt_code(code)
    # TODO: Need to implement
  end

  def code_valid?(code)
    # TODO: Need to implement
  end
end

##
# This class represents a player, whom will
# play the Mastermind game.
class Player
  attr_accessor :name
  attr_reader :game_mark

  def initialize(name)
    @name = name
  end

  def enter_choice
    puts "\n#{name} enter your next move:"
    gets.chomp
  end
end

##
# This class runs the actual Mastermind
# game.
class GameManager
  def initialize(player_name)
    @player = Player.new(player_name)

    @game = Mastermind.new
  end

  def play_games
    puts "\nWelcome to this Mastermind game!\n\n"

    loop do
      play_game

      break unless play_another_game?

      @game.new_game
    end
  end

  def play_game
    loop do
      @game.print_game
      enter_player_choice

      break if game_over?
    end

    @game.print_game
  end

  def play_another_game?
    puts "\nWould you like to play another game of Mastermind? Enter 'y' or 'n':"

    loop do
      response = gets.chomp.downcase

      return false if response == 'n'
      return true if response == 'y'

      puts "Your response is not valid, enter either 'y' or 'n':"
    end
  end

  def enter_player_choice
    puts 'Selection entered is not valid. ' until @game.play?(@player.enter_choice)
  end

  def game_over?
    if @game.check_winner?
      puts "\nGame over, #{@player.name}, you won the game!"
      return true
    end

    unless @game.more_choices_remaining?
      puts "\nGame over, #{@player.name},you lost the game"
      return true
    end

    false
  end
end

game_manager = GameManager.new('Player 1')
game_manager.play_games
