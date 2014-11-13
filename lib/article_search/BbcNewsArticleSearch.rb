require_relative '../TwitterWordSearch'
require_relative 'RSSGrabber'
require_relative 'RSSsearch'
require 'pry'

class BbcNewsArticleSearch < RSSGrabber
	include RSS_topic_search

	attr_reader :articles, :followers

	def initialize
		search = TwitterWordSearch.new
		@articles = get_response("http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml")
		@followers = search.get_follower_count("Bbc")/1000000
		@image = :media_thumbnail_url
		@articles = convert(self.articles)
		@articles.each do |article|
   			article[:source] = "BBC"
 		end 
	end
end



