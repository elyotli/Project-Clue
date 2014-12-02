require 'uri'
require 'net/http'
require 'twitter'
require 'json'
require 'awesome_print'

module PopularitySearch
  TWITTER_BASE_URL = "http://urls.api.twitter.com/1/urls/count.json?url="
  FACEBOOK_BASE_URL = "http://graph.facebook.com/?id="
  TWITTER_CONSUMER_KEY = "pn5orCjkWymq7dLFZwf1rJWLB"
  TWITTER_CONSUMER_SECRET ="1KzC4wZOgU8qlgZlozDJtL6o1cPWNzSmLGmmuvRg6Tr1OkX0i8"
  
  def twitter_popularity(url)
    result_json = JSON.parse(get_request(TWITTER_BASE_URL + url))
    result_json["count"]
  end

  def facebook_popularity(url)
    result_json = JSON.parse(get_request(FACEBOOK_BASE_URL + url))
    result_json["shares"]
  end

  def twitter_follower_count(user)
    twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key    = TWITTER_CONSUMER_KEY
      config.consumer_secret = TWITTER_CONSUMER_SECRET
    end
    follower = twitter_client.user("#{user}")
    follower.followers_count
  end

  private
  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

end