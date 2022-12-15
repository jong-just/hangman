require 'csv'

# toolbox for methods needed throughout the game
module Toolbox
  # returns contents in a csv file named 'word_dictionary'
  def open_csv
    CSV.open('word_dictionary.csv', headers: false)
  end

  MAXROUNDS = 6
end

# class to hold player's data
class Player
  attr_accessor :word

  def initialize(word)
    @word = word
  end
end

# class to hold all of methods for the game of hangman
class Hangman
  include Toolbox

  @@answer_word_scrambled_array = []
  @@incorrect_count = 0
  @@win = false
  @@lose = false
  @@end = false
  @@good_input = false

  private

  # returns a random integer from 0 to size of given array
  def rng(array_for_size)
    rand(1..array_for_size.size).to_i
  end

  # returns a word randomly selected from dictionary array
  def generate_word
    dictionary_array = generate_dictionary_array
    @@guess_word = dictionary_array[rng(dictionary_array)].join('')
  end

  # returns array of words from csv file
  def generate_dictionary_array
    dictionary_array = []
    dictionary = open_csv

    # adds any words between 5 to 12 words into an array
    dictionary.each do |word|
      if word.join("").length > 5 && word.join("").length < 12
        dictionary_array << word
      end
    end

    return dictionary_array
  end

  # creates the array that will show the progress of the game i.e. word -> ____
  def scramble_guess_word
    @@guess_word.length.times do
      @@answer_word_scrambled_array << "_"
    end
  end

  # method for getting player's input
  def player_input
    until @@good_input do
      output = input_validation(gets.chomp.downcase)
    end
    @@good_input = false
    return output
  end

  # method that checks if input is only 1 letter and is actually a letter
  def input_validation(letter)
    if letter.length != 1
      puts "Please input one letter."
    elsif letter.upcase != letter
      @@good_input = true
      return letter
    else
      puts "Please input a letter."
    end
  end

  # core game mechainc that checks if the player's letter guess is in the word
  def check_player_guess
    good_letter = false
    count = 0
    @@guess_word.split('').each_with_index do |letter, idx|
      if letter == @@player_guess.word
        @@answer_word_scrambled_array[idx] = letter
        good_letter = true
        count+=1
      end
    end

    if good_letter == false
      puts "#{@@player_guess.word} was not in the word."
      @@incorrect_count+=1
    elsif good_letter
      puts "#{@@player_guess.word} was in #{count} time[s]."
    else
      puts "Uh-oh. ERRRORR!!"
    end
    puts "Guess word array: #{@@answer_word_scrambled_array.join}"
    p @@guess_word
  end

  # test output, can be deleted after finish
  def output_scrambled
    puts @@answer_word_scrambled_array.join
  end

  # method for generating the player object and getting first initial guess
  def get_initial_player_guess
    @@player_guess = Player.new(player_input)
  end

  # method for getting player's word guess attempts
  def get_player_guess
    @@player_guess.word = player_input
  end

  # calls methods to play one round
  def play_round
    get_player_guess
    check_player_guess
  end

  # method that contains the string of methods needed to set up a new game
  def game_setup
    generate_word
    scramble_guess_word
    output_scrambled
    get_initial_player_guess
    check_player_guess
    output_chances_left
  end

  # method that outputs the current chances left
  def output_chances_left
    puts "You have #{MAXROUNDS-@@incorrect_count}/#{MAXROUNDS} chances left.\n \n"
  end

  # method that checks if the player has won or not
  def win_check
    if @@guess_word == @@answer_word_scrambled_array.join
      @@end = true
      @@win = true
    end
  end

  # method that chekcs if the player has long all chances and therefore lost
  def lose_check
    if @@incorrect_count == MAXROUNDS
      @@end = true
      @@lose = true
    end
  end

  # method that calls both the loss and win checks
  def end_condition_check
    lose_check
    win_check
  end

  public

  # method for playing a new game
  def play_game
    game_setup
    until @@end do
      play_round
      end_condition_check
      output_chances_left
    end
    if @@lose
      puts "You lose! The word was #{@@guess_word}."
    elsif @@win
      puts "You win! The word was #{@@guess_word}"
    else
      puts "Uh-oh, another error at play_game!!"
    end
  end
end

puts "Game starting!"

new_game = Hangman.new

new_game.play_game