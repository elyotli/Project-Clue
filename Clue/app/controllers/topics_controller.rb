class TopicsController < ApplicationController
	def index
    params[:date_id] ? day = Day.find(params[:date_id]) : day = Day.last
    @topics = day.topics.first(4);
    @articles = @topics.first().articles.first(4);
    @dataset = Popularity.popularitiesAsJSON(@topics.first.popularities.first(30))
	end

  def popularity
    @popularities = Popularity.where(topic_id: params[:topic_id])
    Popularity.popularitiesAsJSON(@popularities)
  end

  def show
    @topic = Topic.find(params[:id])
    @articles = @topic.articles
  end
end

