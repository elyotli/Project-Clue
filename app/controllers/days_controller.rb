class DaysController < ApplicationController
  def topics
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)

    # @articles and @day are being used in the partial
   	render partial: 'topics/topic', local: @topics, layout: false
  end

  def articles
    # @day = Day.where(date: params[:date]).first
    # @topics = @day.topics.first(4)
    # @articles = @topics.first().articles.first(4)
    # @articles_per_page = 4
    # @total_articles = @topics.first().articles.count
    # @current_page = 1
    # @total_pages = (@topics.first().articles.count / 4.0).ceil

    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)
    @articles = @topics.first().articles.order('published_at DESC').first(4)
    @articles_per_page = 4
    @total_articles = @all_articles.count
    @current_page = 1
    @total_pages = (@total_articles / 4.0).ceil

    render partial: 'topics/article', layout: false
  end

  def popularity
  	@day = Day.where(date: params[:date]).first
    @topics = @day.topics
  	@popularities = Popularity.where(topic_id: @topics.first.id)
    render json: Popularity.popularitiesAsJSON(@popularities)
  end
end
