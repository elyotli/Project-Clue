require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'
# require_relative "TwitterURLSearch"

class APIControl
  def initialize
  end

  def get_request
    uri = URI.parse(@processed_url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    p response
    return response.body
  end

  def get_tweet_count(article)
    client = TwitterURLSearch.new
    client.set_params(article.url)
    client.get_response["count"]
  end

  private

  def parse_JSON(response)
    JSON.parse(response)
  end
end


class Story
  attr_accessor :title, :url, :abstract, :source, :image_url, :published_at, :twitter_popularity
  def initialize
  end
end
