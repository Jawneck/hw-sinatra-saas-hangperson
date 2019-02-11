class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses 
  attr_accessor :check_win_or_lose
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '' 
    @check_win_or_lose=:play
    
     word.each_char do |i|
      @word_with_guesses << '-'
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(letter)
    
    #Throw errors
    raise ArgumentError if letter.nil?
    raise ArgumentError if letter == ''
    raise ArgumentError if !letter.match(/[a-zA-Z]/)

    #Convert letter to lowercase
    letter.downcase!
    
    #Check if letter in word unless guessed
    if word.include? letter
      unless guesses.include? letter
        guesses << letter
        
        #Loop through word
        for i in 0..word.length
          if word[i] == letter
            word_with_guesses[i] = letter
            #Win if all word guessed
            @check_win_or_lose = :win if !word_with_guesses.include? '-'
          end
        end
        return true
      end
    else
      unless wrong_guesses.include? letter
        wrong_guesses << letter
        #Wrong guess greater or equal to 7
        if wrong_guesses.size >= 7
          @check_win_or_lose = :lose
        end
        
        return true
      end
    end
    return false #if guessed letter not in word
  end
end
