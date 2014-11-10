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

# client = RSSGrabber.new

# ap client.get_response("http://www.cbsnews.com/latest/rss/main")

#   def get_response_fox
#     @rss_url = url
#     rss = SimpleRSS.parse(get_request)
#     full_items = rss.channel.items
#     full_items.each do |item|
#       @titles << item.title
#       @links[item.title] = item.feedburner_origLink.match(/.*[.][?]/).to_s[0..-2]
#       @descriptions[item.title] = item.description.match(/.*[.]/).to_s[0..-2]
#     end
#   end

#   def get_response_cnn
#     rss = SimpleRSS.parse(get_request)
#     full_items = rss.channel.items
#     articles = []
#     full_items.each do |item|
#       article = Story.new
#       article.title = item.title
#       article.url = item.guid
#       article.abstract = item.description.match(/.*[.][&]/).to_s
#       article.published_at = item.pubDate
#       ap article
#       articles << article
#     end
#     return articles
#   end

#   def get_response_wsj_wn
#     @rss_url = "http://online.wsj.com/xml/rss/3_7085.xml"  #wsj world news rss
#     rss = SimpleRSS.parse(get_request)
#     full_items = rss.channel.items
#     articles = []
#     ap full_items
#   end

#   def find_articles(keyphrase)
#     articles = get_response_cnn
#     articles.title
#   end
# end

# client = RSSGrabber.new("http://online.wsj.com/xml/rss/3_7014.xml")

# client.get_response_wsj(url)

# client = RSSGrabber.new("http://rss.cnn.com/rss/cnn_topstories.rss")
# cnn_articles = client.get_response_cnn
# # ap cnn_articles
# puts "Titles: "
# ap client.titles
# puts "Links: "
# ap client.links
# puts "Descriptions: "
# ap client.descriptions
# puts ""

# client = RSSGrabber.new("http://feeds.foxnews.com/foxnews/most-popular")
# fox_articles = client.get_response_fox
# # ap fox_articles
# puts "Titles: "
# ap client.titles
# puts "Links: "
# ap client.links
# puts "Descriptions: "
# ap client.descriptions
