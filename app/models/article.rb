class Article < ActiveRecord::Base
	validates :url, presence: true
	validates :title, presence: true

	has_many :article_topics
	has_many :topics, through: :article_topics

	def totalPop
		self.twitter_popularity + self.facebook_popularity + self.google_trend_index
	end


  #can you put the twitter_popularity,facebook_popularity value population in some kind of lifecycle hook?
end
