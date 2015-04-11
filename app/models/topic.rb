class Topic < ActiveRecord::Base
  	has_many :articles
	has_many :popularities

	validates :name, presence: true, uniqueness: true

	def last_updated
		self.popularities.order('date').last.date
	end

end
