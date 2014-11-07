class Topic < ActiveRecord::Base
	has_many :article_topics
	has_many :day_topics
	has_many :days, through: :day_topics
	
	has_many :popularities
end
