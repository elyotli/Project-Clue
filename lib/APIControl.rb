require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

#Module
class APIControl

  #combine json parsing and get_request
  def get_request
    uri = URI.parse(@processed_url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  private

  def parse_JSON(response)
    JSON.parse(response)
  end
end

#Ditch this and use article
class Story
  attr_accessor :title, :url, :abstract, :source, :image_url, :published_at, :twitter_popularity, :facebook_popularity
  def initialize
  end
end
