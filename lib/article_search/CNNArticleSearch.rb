require_relative '../TwitterWordSearch'
require_relative 'RSSGrabber'
require_relative 'RSSsearch'
require 'pry'

class CNNArticleSearch < RSSGrabber
	include RSS_topic_search

	attr_reader :articles, :followers

	def initialize
		search = TwitterWordSearch.new
		@articles = get_response("http://rss.cnn.com/rss/cnn_topstories.rss")
		@followers = search.get_follower_count("CNN")/1000000
		@image = :media_content_url
		@articles = convert(self.articles)
		@articles.map! do |article|
   			article[:source] = "CNN"
 		end 
	end

end


