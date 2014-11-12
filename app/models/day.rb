class Day < ActiveRecord::Base

	validates :date, presence: true

	has_many :day_topics
	has_many :topics, through: :day_topics

  def create_day
    Day.create!(date: Date.today)
  end

  def self.get_today
  	Day.all.order('date DESC').first
  end

end
