require_relative 'config/application'

require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'
require 'twitter'
require 'simple_oauth'
require 'nokogiri'



def search_tweet(search_word)
  tweet_arr = []
  search_word = URI.parse(search_word)
  # word_to_search = ARGV[0..-1]
  TWITTER_CLIENT.search("#{search_word}", :lang => "en", :result_type => "recent").take(10).each do |tweet|
    p "Tweet Text: "
    ap tweet.text
    p "Tweet Retweet Count: "
    ap tweet.retweet_count
    p "Tweet Favorite Count: "
    ap tweet.favorite_count
    p "Tweet Created at: "
    ap tweet.created_at
    tweet_arr << tweet
  end
end

ap search_tweet("Election")

  def get_url(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

### This Is Working ###

p "Straight from API: "
ap JSON.parse(get_url("http://urls.api.twitter.com/1/urls/count.json?url=http://www.nytimes.com/2014/11/07/us/politics/republican-wins-may-lead-to-fiscal-deal-with-democrats.html?hp&action=click&pgtype=Homepage&module=photo-spot-region&region=top-news&WT.nav=top-news"))

#######################


### This Is Working ###
i = 0
TWITTER_CLIENT.trends(id = 1, options = {exclude: 'hashtags'}).each do |trend|
  p i
  ap trend
  i += 1
end

######################