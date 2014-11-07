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
  end

  def search_tweet(search_word)
    tweet_arr = []
    search_word = URI.parse(search_word)
    TWITTER_CLIENT.search("#{search_word}", :lang => "en", :result_type => "mixed").take(100).each_with_index do |tweet, index|
      p index
       p "Tweet Text: "
      ap tweet.text
      p "Tweet Retweet Count: "
      ap tweet.retweet_count
      p "Tweet Favorite Count: "
      ap tweet.favorite_count
      p "user: "
      ap tweet.user.name
      ap tweet.created_at
      tweet_arr << tweet
    end
  end
end

tws = TwitterWordSearch.new
tws.search_tweet("")
