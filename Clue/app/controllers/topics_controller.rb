class TopicsController < ApplicationController
	def index
    params[:date_id] ? day = Day.find(params[:date_id]) : day = Day.last
    @day_str = day.date.to_s
    @day = day
    @topics = day.topics.first(4)
    @articles = @topics.first().articles.first(4)
    @dataset = Popularity.popularitiesAsJSON(@topics.first.popularities.first(30))
    @articles_per_page = 4
    @total_articles = @topics.first().articles.count
	end

  def articles_page
    articles_per_page = 4
    date = Day.find(params[:date_id]).date.to_s
    page = params[:page].to_i - 1
    @articles = Topic.find(params[:topic_id]).articles.where(published_at: date).offset(page * articles_per_page).limit(4)
    render partial: 'topics/article', local: @articles, layout: false
  end

  def popularity
    @popularities = Popularity.where(topic_id: params[:topic_id])
    render json: Popularity.popularitiesAsJSON(@popularities)
  end

  def show
    @topic = Topic.find(params[:id])
    @articles = @topic.articles
  end
end

