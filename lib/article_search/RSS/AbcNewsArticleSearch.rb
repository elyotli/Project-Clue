require_relative 'RSSProcesser'

class AbcNewsArticleSearch < RSSProcesser
	attr_accessor :articles, :followers

	def initialize
 		@raw_articles = get_response("http://feeds.abcnews.com/abcnews/topstories")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "ABC"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("ABC")
	end
end



