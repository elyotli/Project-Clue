class Article < ActiveRecord::Base
	validates :url, presence: true
	validates :title, presence: true

	has_many :article_topics
	has_many :articles, through: :article_topics

	def totalPop
		self.twitter_popularity + self.facebook_popularity + self.google_trend_index
	end

end
