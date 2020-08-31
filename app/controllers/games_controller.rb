require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].delete(' ').chars
    @word_array = params[:word].chars
    @word = params[:word]
    @valid = find_word(params[:word])
    session[:score] = session[:score] || 0
    letters_in_common = @word_array & @letters

    @result = if @valid && @word.length <= 10
                if letters_in_common.count == @word_array.count
                  session[:score] += @word.length
                  "Congratulations! #{@word} is a valid English word! Your score now is #{session[:score]}"
                else
                  "Sorry but #{@word} cannot be build out of #{@letters.join(', ')}"
                end
              else
                "Sorry but #{@word} does not seem to be a valid English word"
              end
    @score = session[:score]
  end

  private

  def find_word(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    json = JSON.parse(response)
    json['found']
  end
end
