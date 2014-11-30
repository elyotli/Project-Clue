require_relative 'RSSProcesser'

class CNNArticleSearch < RSSProcesser
	attr_reader :articles, :followers

	def initialize
		@raw_articles = get_response("http://rss.cnn.com/rss/cnn_topstories.rss")
		@articles = format(@raw_articles)
		@articles.each do |article|
			if article[:abstract].scan(/\&/).length > 0
				str = article[:abstract]
				article[:abstract] = str[0..str.index(/\&/)-1]
				if article[:abstract][0] == "&"
					article[:abstract] = ""
				end
			end
   			article[:source] = "CNN"
 		end
	end

	def twitter_follower_count
		@followers = twitter_follower_count("CNN")
	end
end
