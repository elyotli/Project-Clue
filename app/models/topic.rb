class Topic < ActiveRecord::Base
  	has_many :articles
	has_many :popularities




end
