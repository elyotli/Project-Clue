class Day < ActiveRecord::Base
	validates :date, presence: true

	has_many :day_topics
	has_many :topics, through: :day_topics
end
