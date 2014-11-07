require_relative "API_Control"

require 'json'
require 'awesome_print'
require 'twitter'

PROJ_CLUE_CONSUMER_KEY = "pn5orCjkWymq7dLFZwf1rJWLB"
PROJ_CLUE_CONSUMER_SECRET ="1KzC4wZOgU8qlgZlozDJtL6o1cPWNzSmLGmmuvRg6Tr1OkX0i8"
PROJ_CLUE_TOKEN = "30163876-h8eLKbPqOR3QAjuakwMTWjk45jgtitn0gQmwtMxk8"
PROJ_CLUE_TOKEN_SECRET = "PArLmsMPEGZOagLNSd8gkejjNje4mcmEFhNkAOdOF1SSy"

TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key    = PROJ_CLUE_CONSUMER_KEY
  config.consumer_secret = PROJ_CLUE_CONSUMER_SECRET
end



class TwitterWordSearch < APIControl

  def initialize
    @tweet_arr = []
    @total_tweet_popularity = 0
  end

  def search_tweet(search_word)
    search_word = URI.parse(search_word)
    twit_search = TWITTER_CLIENT.search("#{search_word}", :lang => "en", :result_type => "recent").take(100)
    twit_search.each{|tweet| @tweet_arr << tweet.favorite_count + tweet.retweet_count}
    @total_tweet_popularity += @tweet_arr.inject(:+)
    return @total_tweet_popularity
  end

end

tws = TwitterWordSearch.new
ap tws.search_tweet("Ebola")
