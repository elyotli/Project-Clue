require_relative 'RSSProcesser'

class ReutersArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://feeds.reuters.com/reuters/topNews")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "Reuters"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("reuters")
	end
end
