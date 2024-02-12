# frozen_string_literal: true

##
# This class represents the Mastermind game.
class Mastermind
  VALID_CODES = %w[A B C D E F].freeze
  BLACK = 'B'
  WHITE = 'W'
  MISS = '-'
  RESPONSE_CODES = [BLACK, WHITE, MISS].freeze
  CODE_LENGTH = 4
  NUMBER_OF_ATTEMPTS = 8

  def initialize
    new_game
  end

  def new_game(secret_code = nil)
    secret_code = secret_code ? secret_code.upcase : ''

    @secret_code = self.class.code_valid?(secret_code) ? secret_code : self.class.random_code
    @results = []
  end

  def play?(choice)
    return false unless choice

    choice = choice.upcase
    response = self.class.attempt_code(choice, @secret_code)

    return false unless response

    result_entry = {
      attempt: choice,
      feedback: response
    }

    @results.push(result_entry)

    true
  end

  def check_winner?
    winning_result = BLACK * CODE_LENGTH
    @results.any? { |result| result[:feedback] == winning_result }
  end

  def more_choices_remaining?
    @results.length < NUMBER_OF_ATTEMPTS
  end

  def print_game
    puts '-' * (CODE_LENGTH * 4 + 3)

    full_results = @results.clone

    # The table that's printed will always be NUMBER_OF_ATTEMPTS rows
    while full_results.length < NUMBER_OF_ATTEMPTS
      full_results.push({ attempt: ' ' * CODE_LENGTH, feedback: ' ' * CODE_LENGTH })
    end

    full_results.reverse.each do |result|
      puts "|  #{result[:attempt]}  |  #{result[:feedback]}  |"
      print_row_separator
    end
  end

  def print_row_separator
    print "|#{'-' * (CODE_LENGTH + 4)}" * 2
    puts '|'
  end

  class << self
    def code_valid?(code)
      return false unless code && code.length == CODE_LENGTH

      code.upcase.split('').each do |char|
        return false unless VALID_CODES.include?(char)
      end

      true
    end

    def random_code
      new_code = ''
      CODE_LENGTH.times { |_| new_code += VALID_CODES.sample }

      new_code
    end

    def attempt_code(selected_code, final_code)
      return nil unless code_valid?(selected_code) && code_valid?(final_code)

      attempt_info = {
        code_list: selected_code.split(''),
        secret_list: final_code.split(''),
        feedback: ''
      }

      process_exact_matches(attempt_info)
      process_off_matches(attempt_info)
      process_no_matches(attempt_info)

      attempt_info[:feedback]
    end

    private

    # This processes the codes that are correct and with the correct positions
    def process_exact_matches(attempt_info)
      attempt_info[:secret_list].length.times do |index|
        next unless attempt_info[:code_list][index] == attempt_info[:secret_list][index]

        attempt_info[:code_list][index] = nil
        attempt_info[:secret_list][index] = nil
        attempt_info[:feedback] += BLACK
      end

      attempt_info[:code_list].compact!
      attempt_info[:secret_list].compact!
    end

    # This processes the codes that are correct, but their positions are wrong
    def process_off_matches(attempt_info)
      attempt_info[:secret_list].length.times do |index|
        index_found = attempt_info[:secret_list].find_index(attempt_info[:code_list][index])

        next unless index_found

        attempt_info[:code_list][index] = nil
        attempt_info[:secret_list][index_found] = nil
        attempt_info[:feedback] += WHITE
      end
    end

    # This processes the codes that are not correct
    def process_no_matches(attempt_info)
      attempt_info[:feedback] += MISS * CODE_LENGTH
      attempt_info[:feedback] = attempt_info[:feedback][0, CODE_LENGTH]
    end
  end
end

##
# This class represents a player, whom will
# play the Mastermind game.
class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def enter_choice
    puts "\n#{name} enter your next move:"
    gets.chomp
  end
end

##
# This class is the Computer AI that will
# attempt to figure out the secret code.
class Computer
  def initialize(game)
    @game = game
  end

  def find_code
    while @game.more_choices_remaining?
      break if @game.check_winner?

      @game.play?(guess_code)
    end
  end

  def guess_code
    Mastermind.random_code
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
    print_instructions

    loop do
      play_game

      break unless play_another_game?

      @game.new_game
    end
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
end

##
# This class runs the traditional Mastermind
# mode of the game where a random secret code
# is generated and the player tries to guess
# it.
class CodeBreaker < GameManager
  def play_game
    loop do
      @game.print_game
      enter_player_choice

      break if game_over?
    end

    @game.print_game
  end

  def print_instructions
    puts "\nWelcome to this Mastermind game!\n\n"
    puts 'In this game, a secret code consisting'
    puts "of the following characters is generated:\n\n"
    puts "  #{Mastermind::VALID_CODES.join('  ')}\n\n"
    puts "The code is #{Mastermind::CODE_LENGTH} letters long and duplicates"
    puts "are allowed.  You will be given #{Mastermind::NUMBER_OF_ATTEMPTS} chances"
    puts "to guess the code.\n\n"
    print_results_instructions
  end

  def print_results_instructions
    puts 'After each guess, results will be displayed.'
    puts "The results will be #{Mastermind::CODE_LENGTH} characters long and"
    puts "will consist of the following characters:\n\n"
    puts "#{Mastermind::RESPONSE_CODES[0]}: One character of your code is correct and"
    puts "   is in the correct position.\n\n"
    puts "#{Mastermind::RESPONSE_CODES[1]}: One character of your code is correct but"
    puts "   is in the wrong position.\n\n"
    puts "#{Mastermind::RESPONSE_CODES[2]}: One character of your code is incorrect.\n\n"
    puts 'The results does not show any information about order'
    puts "or which code is correct or wrong.\n\n"
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

##
# This class runs the reverse Mastermind
# mode of the game where the player makes
# a secret code and the computer tries to
# guess it.
class CodeMaker < GameManager
  def initialize(name)
    super(name)
    @computer = Computer.new(@game)
  end

  def play_game
    enter_player_choice

    loop do
      @computer.find_code

      break if game_over?
    end

    @game.print_game
  end

  def print_instructions
    puts "\nWelcome to this reverse mode Mastermind game!\n\n"
    puts 'In this game, you will choose a secret code using'
    puts "the following characters:\n\n"
    puts "  #{Mastermind::VALID_CODES.join('  ')}\n\n"
    puts "The code needs to be #{Mastermind::CODE_LENGTH} letters long and duplicates"
    puts 'are allowed.  The Computer will then try to guess the code'
    puts "and will be given #{Mastermind::NUMBER_OF_ATTEMPTS} chances to guess it."
    puts 'All of the guesses will be displayed along with the final'
    puts "results.\n\n"
  end

  def enter_player_choice
    secret_code = nil
    loop do
      secret_code = @player.enter_choice
      break if Mastermind.code_valid?(secret_code)

      puts 'Code entered is not valid'
    end

    @game.new_game(secret_code)
  end

  def game_over?
    if @game.check_winner?
      puts "\nGame over, #{@player.name},you lost the game"
      return true
    end

    unless @game.more_choices_remaining?
      puts "\nGame over, #{@player.name}, you won the game!"
      return true
    end

    false
  end
end

# game = CodeBreaker.new('Player 1')
game = CodeMaker.new('Player 1')
game.play_games
