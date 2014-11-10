class Day < ActiveRecord::Base

	validates :date, presence: true

	has_many :day_topics
	has_many :topics, through: :day_topics

  def create_day
    Day.create!(date: Date.today)
  end

end
