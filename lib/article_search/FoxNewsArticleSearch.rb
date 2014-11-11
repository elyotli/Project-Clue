require_relative '../TwitterWordSearch'
require_relative 'RSSGrabber'
require_relative 'RSSsearch'

class FoxNewsArticleSearch < RSSGrabber
	include RSS_topic_search

	attr_reader :articles, :followers

	def initialize
		search = TwitterWordSearch.new
		@articles = get_response("http://feeds.foxnews.com/foxnews/most-popular")
		@followers = search.get_follower_count("FoxNews")/1000000
		convert(self.articles)
	end

end
