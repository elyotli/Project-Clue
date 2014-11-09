require_relative "API_control"
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'


class PopularitySearch
  @@twitter_base_url = "http://urls.api.twitter.com/1/urls/count.json?url="
  @@facebook_base_url = "http://graph.facebook.com/?id="

  def initialize
    @twitter_processed_url = ""
    @facebook_processed_url = ""
  end

  def set_params(url)
    @twitter_processed_url = @@twitter_base_url + url
    @facebook_processed_url = @@facebook_base_url + url
  end

  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  def get_twitter_popularity
    result_json = JSON.parse(get_request(@twitter_processed_url))
    result_json["count"]
  end

  def get_facebook_popularity
    result_json = JSON.parse(get_request(@facebook_processed_url))
    result_json["shares"]
  end

end

# puts "*" * 30
# client = TwitterURLSearch.new

# client.set_params("mm4a.org/1wA1qCl")
# ap client.get_response
# puts "*" * 30
# puts "*" * 30
# client2 = TwitterURLSearch.new
# client2.set_params("http://www.nytimes.com/2014/11/07/opinion/paul-krugman-triumph-of-the-wrong.html")
# ap client2.get_response
# puts "*" * 30
