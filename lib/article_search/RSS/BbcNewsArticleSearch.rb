require_relative 'RSSProcesser'

class BbcNewsArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "BBC"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("BBCBreaking")
	end
end