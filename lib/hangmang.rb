require 'csv'

# toolbox for methods needed throughout the game
module Toolbox
  # returns contents in a csv file named 'word_dictionary'
  def open_csv
    CSV.open('word_dictionary.csv', headers: false)
  end
end

# class to hold all of methods for the game of hangman
class Hangman
  include Toolbox

  @@current_guess = []
  @@guess_word
  @@guess_word_array = []

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

  def test_output
    puts @@guess_word
  end

  def test_output_scrambled
    scramble_guess_word
    puts @@guess_word_array.join
  end

  private

  def output_guess_word
    puts @@current_guess
  end

  def scramble_guess_word
    @@guess_word.length.times do
      @@guess_word_array << "_"
    end
  end

end

# class to hold player's data
class Player
  @@guess_array
  def get_player_guess
    gets.chomp 
  end
end

puts "Game starting!"

new_game = Hangman.new

new_game.generate_word
new_game.test_output
new_game.test_output_scrambled