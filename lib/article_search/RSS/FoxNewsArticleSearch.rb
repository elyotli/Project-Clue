require_relative 'RSSProcesser'

class FoxNewsArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://feeds.foxnews.com/foxnews/most-popular")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "Fox"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("FoxNews")
	end
end

