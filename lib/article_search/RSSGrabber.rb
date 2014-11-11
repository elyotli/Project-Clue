require 'simple-rss'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'
require_relative '../APIControl'

class RSSGrabber
  attr_accessor :titles, :links, :descriptions
  def initialize
    @titles = []
    @links = {}
    @descriptions = {}
  end

  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  def get_response(url)
    rss = SimpleRSS.parse(get_request(url))
    full_items = rss.channel.items
  end
end


