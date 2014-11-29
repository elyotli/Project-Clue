require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'

module Requests_and_Responses

  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port){ |http| http.request request }
    return response.body
  end

  def get_twitter_popularity(url)
    article_twitter_popularity = JSON.parse(get_request("http://urls.api.twitter.com/1/urls/count.json?url=" + url.to_s))["count"]
  end

  def get_facebook_popularity(url)
    JSON.parse(get_request("http://graph.facebook.com/?id=" + url.to_s))["shares"]
  end

  def get_response_nyt
    articles = []
    time_span = Date.today.prev_day.strftime.gsub(/-/, "")
    response = JSON.parse(get_request)["response"]
    response["docs"].each do |item|
      new_article = create_nyt_article(item)
      articles << new_article
    end
    return articles
  end
end

