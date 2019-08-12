# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    # raise
    @result = params[:result].to_f
    @word = params[:word].upcase
    letters = params[:letters]
    if @word.blank?
      @answer = "Your letters: #{letters}. Your word: #{@word}. 0 points! You must enter a word!"
    elsif included?(@word, letters) == false
      @answer = "Your letters: #{letters}. Your word: #{@word}. 0 points! You used invalid letters!"
    elsif english_word?(@word) == true
      @score = compute_score(@word, @result)
      @answer = "Your letters: #{letters}. Your word: #{@word}. Your time: #{@result}. Congratulations! #{@word} is a valid English word! #{@score} points!"
    elsif english_word?(@word) == false
      @answer = "Your letters: #{letters}. Your word: #{@word}. 0 points! Sorry, #{@word} is not a valid English word!"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end

# {"authenticity_token"=>"QnPFb3tQMZU[...]", "word"=>"word"}






# def run_game(attempt, grid, start_time, end_time)
#  result = { time: end_time - start_time }

#  score_and_message = score_and_message(attempt, grid, result[:time])
#  result[:score] = score_and_message.first
#  result[:message] = score_and_message.last

#  result
# end

# def score_and_message(attempt, grid, time)
#  if included?(attempt.upcase, grid)
#    if english_word?(attempt)
#      score = compute_score(attempt, time)
#      [score, "well done"]
#    else
#      [0, "not an english word"]
#    end
#  else
#    [0, "not in the grid"]
#  end
# end

# def english_word?(word)
#  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
#  json = JSON.parse(response.read)
#  return json['found']
# end
