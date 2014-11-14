class Popularity < ActiveRecord::Base
	belongs_to :topic
	belongs_to :day

	def totalPop
		self.twitter_popularity + self.facebook_popularity + self.google_trend_index
	end

	def self.popularitiesAsHash(topic)
    possible_dates = topic.articles.pluck(:published_at).uniq.map do |d|
      d.to_s
    end
    popularities = topic.popularities

    pop_array = []
    popularities.each do |popobj|
      make_dot = false
      if(possible_dates.include? popobj.day.date.to_s)
        make_dot = true
      end
      my_hash = {
        date: popobj.day.date.to_s,
        twitter_popularity: popobj.twitter_popularity,
        facebook_popularity: popobj.facebook_popularity,
        google_trend_index: popobj.google_trend_index,
        day: popobj.day.id,
        make_dot: make_dot
      }
      pop_array << my_hash
    end
    pop_array = pop_array.sort do |h1,h2|
      h1[:date] <=> h2[:date]
    end
    p pop_array
    pop_array
  end

  def self.popularitiesAsJSON(popularities)
    self.popularitiesAsHash(popularities).to_json
  end
end
