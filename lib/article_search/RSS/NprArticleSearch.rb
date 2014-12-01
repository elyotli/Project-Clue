require_relative 'RSSProcesser'

class NprArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://www.npr.org/rss/rss.php")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "NPR"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("nprnews")
	end
end
