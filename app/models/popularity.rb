class Popularity < ActiveRecord::Base
	belongs_to :topic

	validates :date, presence: true
	validates :topic_id, presence: true
	validates :index, presence: true
	validates :date, :uniqueness => {:scope => :topic_id}

	def self.save_data(topic_id, input_data)
		inserts = [] 
		# apparently using an array instead of concatenate reduces garbage strings
		input_data.each do |k, v|
			inserts.push "(#{topic_id}, '#{k}', #{v})"
		end
		sql = "INSERT INTO popularities (topic_id, date, index) VALUES " + inserts.join(", ")
		Popularity.connection.execute sql
	end
end