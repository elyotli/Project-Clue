require_relative '../TwitterWordSearch'
require_relative 'RSSGrabber'
require_relative 'RSSsearch'

class NprArticleSearch < RSSGrabber
	include RSS_topic_search

	attr_reader :articles, :followers

	def initialize
		search = TwitterWordSearch.new
		# @articles = get_response("http://rss.cnn.com/rss/cnn_topstories.rss")
		@articles = get_response("http://www.npr.org/rss/rss.php")
		@followers = search.get_follower_count("nprnews")/1000000
		@articles = convert(self.articles)
		@articles.each do |article|
   			article[:source] = "NPR"
 		end
	end

end
