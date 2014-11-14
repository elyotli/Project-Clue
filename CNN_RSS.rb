require 'uri'
require 'rss'
require 'net/http'
require 'json'
require 'awesome_print'

# def get(url)
#   uri = URI.parse(url)
#   request = Net::HTTP::Get.new(uri)
#   response = Net::HTTP.start(uri.host, uri.port) do |http|
#     http.request request
#   end
# end

url = 'http://rss.cnn.com/rss/cnn_topstories.rss'

# get(url) do |rss|
#   feed = RSS::Parser.parse(rss)
#   p feed
#   # puts "Title: #{feed.channel.title}"
#   # feed.items.each do |item|
#   #   puts "Item: #{item.title}"
#   # end
# end



open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  # ap feed
  # puts "Title: #{feed.channel.title}"
  feed.items.each do |item|
    ap item
    puts
    puts
    # puts "Item: #{item.title}"
  end
end
