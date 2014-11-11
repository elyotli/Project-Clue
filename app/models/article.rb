class Article < ActiveRecord::Base
	# validates :url, presence: true
	# validates :title, presence: true

	has_many :article_topics
	has_many :topics, through: :article_topics

	def totalPop
		self.twitter_popularity + self.facebook_popularity + self.google_trend_index
	end

  # def get_twitter_popularity
  #   self.twitter_popularity = #call the twitter pop method
  # end

  # def get_facebook_popularity
  #   self.facebook_popularity #call the facebook pop method
  # end


end
