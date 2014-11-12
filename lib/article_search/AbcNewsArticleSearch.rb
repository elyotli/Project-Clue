require_relative '../TwitterWordSearch'
require_relative 'RSSGrabber'
require_relative 'RSSsearch'
require 'pry'

class AbcNewsArticleSearch < RSSGrabber
	include RSS_topic_search

	attr_accessor :articles, :followers

	def initialize
		search = TwitterWordSearch.new
		@articles = get_response("http://feeds.abcnews.com/abcnews/topstories")
		@image = :media_thumbnail_urs
		@followers = search.get_follower_count("ABC")/1000000
		@articles = convert(self.articles)

		@articles.each do |article|
   			article[:source] = "ABC"
 		end 
	end
end



