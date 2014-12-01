require 'json'
require 'awesome_print'
require 'twitter'

class TwitterWordSearch
  attr_accessor :time_elapsed

  PROJ_CLUE_CONSUMER_KEY = "pn5orCjkWymq7dLFZwf1rJWLB"
  PROJ_CLUE_CONSUMER_SECRET ="1KzC4wZOgU8qlgZlozDJtL6o1cPWNzSmLGmmuvRg6Tr1OkX0i8"
  PROJ_CLUE_TOKEN = "30163876-h8eLKbPqOR3QAjuakwMTWjk45jgtitn0gQmwtMxk8"
  PROJ_CLUE_TOKEN_SECRET = "PArLmsMPEGZOagLNSd8gkejjNje4mcmEFhNkAOdOF1SSy"

  def initialize
    @tweet_id_arr = []
    @total_retweets = 0
    @current_tweet_id = 0
    @current_tweet_time = 0
    @time_elapsed

    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key    = PROJ_CLUE_CONSUMER_KEY
      config.consumer_secret = PROJ_CLUE_CONSUMER_SECRET
    end
  end

  def search_tweet(search_word, find_before=nil)
    # parsed_search_word = URI.parse(search_word)
     #parsed_search_word = search_word.split(" ").join("+")
    twit_search = @twitter_client.search("#{search_word}", :lang => "en", :result_type => "recent", :max_id => find_before).take(100)
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
    results = {"time" => @time_elapsed.to_i, "retweets" => @total_retweets, "num tweets" => @tweet_id_arr.length}
    return results
  end

  def get_follower_count(user)
    follower = @twitter_client.user("#{user}")
    follower.followers_count
  end
end