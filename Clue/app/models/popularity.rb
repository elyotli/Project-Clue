class Popularity < ActiveRecord::Base
	belongs_to :topic
	belongs_to :day

	def totalPop
		self.twitter_popularity + self.facebook_popularity + self.google_trend_index
	end
end
