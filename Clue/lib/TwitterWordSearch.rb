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
  attr_accessor :time_elapsed

  def initialize
    @tweet_id_arr = []
    @total_retweets = 0
    @current_tweet_id = 0
    @current_tweet_time = 0
    @time_elapsed
  end

  def search_tweet(search_word, find_before=nil)
    parsed_search_word = URI.parse(search_word)
    twit_search = TWITTER_CLIENT.search("#{parsed_search_word}", :lang => "en", :result_type => "recent", :max_id => find_before).take(100)
    num_results = twit_search.count

    twit_search.each do |tweet|
      @tweet_id_arr << tweet.id
      @total_retweets += tweet.retweet_count
      @current_tweet_id = tweet.id
      @current_tweet_time = tweet.created_at
    end
    @time_elapsed = Time.now - @current_tweet_time
    if num_results > 99 && @tweet_id_arr.length < 999
      search_tweet(search_word, @current_tweet_id)
    end
    results = {"time:" => @time_elapsed.to_i, "retweets:" => @total_retweets}
    return results
  end
end

# puts "*" * 30
# ebola_search = TwitterWordSearch.new
# puts "Ebola:"
# ap ebola_search.search_tweet("Ebola")
# puts "*" * 30

# obama_search = TwitterWordSearch.new
# puts "Obama:"
# ap obama_search.search_tweet("Obama")
# puts "*" * 30

# mudpuppies_search = TwitterWordSearch.new
# puts "Mudpuppies:"
# ap mudpuppies_search.search_tweet("mudpuppies")
# puts "*" * 30

# kardashian_search = TwitterWordSearch.new
# puts "Kim Kardashian:"
# ap kardashian_search.search_tweet("Kardashian")
# puts "*" * 30