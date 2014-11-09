require_relative "../API_Control"
require 'simple-rss'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

class CNNArticleSearchRSS
  def initialize
  end

  def get_request
    uri = URI.parse("http://rss.cnn.com/rss/cnn_mostpopular.rss")
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  def get_response
    SimpleRSS.parse(get_request)
  end
end

client = CNNArticleSearchRSS.new
cnn_articles = client.get_response
ap cnn_articles