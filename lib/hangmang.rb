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

  # returns a random integer from 0 to size of given array
  def rng(array_for_size)
    rand(1..array_for_size.size).to_i
  end

  # returns a word randomly selected from dictionary array
  def generate_word
    dictionary_array = generate_dictionary_array
    dictionary_array[rng(dictionary_array)]
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

end

# class to hold player's data
class Player
  def get_player_guess
    gets.chomp 
  end
end

puts "Game starting!"

new_game = Hangman.new

puts new_game.generate_word