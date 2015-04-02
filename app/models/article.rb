class Article < ActiveRecord::Base
	# validates :url, presence: true
	validates :name, presence: true, uniqueness: true

	belongs_to :topic

	def totalPop
		self.twitter_popularity + self.facebook_popularity + self.google_trend_index
	end

end
