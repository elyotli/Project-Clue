require_relative 'RSSProcesser'

class NbcNewsArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://feeds.nbcnews.com/feeds/topstories")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "NBC"
   			article[:abstract] = article[:abstract].gsub(/&lt.*/, "")
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("NBCNews")
	end
end