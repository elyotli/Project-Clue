class Topic < ActiveRecord::Base
	has_many :article_topics
  has_many :articles, through: :article_topics
	has_many :day_topics
	has_many :days, through: :day_topics

	has_many :popularities

  def find_articles

  end



end
