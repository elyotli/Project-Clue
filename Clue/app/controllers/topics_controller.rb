class TopicsController < ApplicationController
	def index
    params[:date_id] ? day = Day.find(params[:date_id]) : day = Day.last
    @topics = day.topics.first(4);
    @articles = @topics.first().articles.first(4);
	end

  def show
    @topic = Topic.find(params[:id])
    @articles = @topic.articles
  end

  def popularity
    @popularities = Popularity.where(topic_id: params[:topic_id])
    pop_array = []
    @popularities.each do |popobj|
      my_hash = {
        date: popobj.day.date,
        twitter_count: popobj.twitter_popularity,
        facebook_count: popobj.facebook_popularity,
        google_count: popobj.google_trend_index
      }
      pop_array << my_hash.to_json
    end
    return pop_array
  end
end

