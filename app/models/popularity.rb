class Popularity < ActiveRecord::Base
	belongs_to :topic

	validates :date, presence: true
	validates :topic_id, presence: true
	validates :index, presence: true
	validates :date, :uniqueness => {:scope => :topic_id}

	def self.save_data(topic, input_data)
		input_data.each do |k, v|
			Popularity.create!(topic: topic, date: k, index: v)
		end
	end
end
