require_relative 'RSSProcesser'

class CbsNewsArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://www.cbsnews.com/latest/rss/main")
		@articles = format(@raw_articles)
		@articles.each do |article|
   			article[:source] = "CBS"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("CBSNews")
	end

end

