require_relative '../TwitterWordSearch'
require_relative 'RSSGrabber'
require_relative 'RSSsearch'

class ReutersArticleSearch < RSSGrabber
	include RSS_topic_search

	attr_reader :articles, :followers

	def initialize
		search = TwitterWordSearch.new
		@articles = get_response("http://feeds.reuters.com/reuters/topNews")
		@followers = search.get_follower_count("reuters")/1000000
		convert(self.articles)
	end

end

