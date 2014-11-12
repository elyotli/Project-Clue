class TopicsController < ApplicationController
	def index
    params[:date_id] ? day = Day.find(params[:date_id]) : day = Day.last
    @day_str = day.date.to_s
    p @day_str
    @day = day
    p @day
    @topics = day.topics.first(4)
    p @topics
    @articles = @topics.first.articles.first(4)
    p @articles
    @dataset = Popularity.popularitiesAsJSON(@topics.first.popularities.first(30))
    p @dataset
    @articles_per_page = 4
    p @articles_per_page
    @total_articles = @topics.first().articles.count
    p @total_articles
    @maxDay = Day.last().date.to_s
    p @maxDay
    @minDay = Day.first().date.to_s
    p @minDay
	end

  def articles_page
    articles_per_page = 4
    date = Day.find(params[:date_id]).date.to_s
    page = params[:page].to_i - 1
    @articles = Topic.find(params[:topic_id]).articles.where(published_at: date).offset(page * articles_per_page).limit(4)
    @total_articles = Topic.find(params[:topic_id]).articles.where(published_at: date).count
    render partial: 'topics/article', local: @articles, layout: false
  end

  def popularity
    @popularities = Popularity.where(topic_id: params[:topic_id])
    render json: Popularity.popularitiesAsJSON(@popularities)
  end

  def articles
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)
    @articles = @topics.first().articles.first(4)
    @articles_per_page = 4
    @total_articles = @topics.first().articles.count
    render partial: 'topics/article', local: @articles, layout: false
  end

  def show
    @topic = Topic.find(params[:id])
    @articles = @topic.articles
  end
end

