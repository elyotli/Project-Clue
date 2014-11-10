class DayTopic < ActiveRecord::Base
	belongs_to :topic
	belongs_to :day
end
