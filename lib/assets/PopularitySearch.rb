require 'uri'
require 'net/http'
require 'twitter'
require 'json'
require 'awesome_print'

module PopularitySearch
  
  def twitter_popularity(url)
    TWITTER_BASE_URL = "http://urls.api.twitter.com/1/urls/count.json?url="
    result_json = JSON.parse(get_request(TWITTER_BASE_URL + url))
    result_json["count"]
  end

  def facebook_popularity(url)
    FACEBOOK_BASE_URL = "http://graph.facebook.com/?id="
    result_json = JSON.parse(get_request(FACEBOOK_BASE_URL + url))
    result_json["shares"]
  end

  def twitter_follower_count(user)
    PROJ_CLUE_CONSUMER_KEY = "pn5orCjkWymq7dLFZwf1rJWLB"
    PROJ_CLUE_CONSUMER_SECRET ="1KzC4wZOgU8qlgZlozDJtL6o1cPWNzSmLGmmuvRg6Tr1OkX0i8"

    TWITTER_CLIENT = Twitter::REST::Client.new do |config|
      config.consumer_key    = PROJ_CLUE_CONSUMER_KEY
      config.consumer_secret = PROJ_CLUE_CONSUMER_SECRET
    end
    follower = TWITTER_CLIENT.user("#{user}")
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