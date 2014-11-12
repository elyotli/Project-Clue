class DaysController < ApplicationController
  def topics
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)

    # @articles and @day are being used in the partial
   	render partial: 'topics/topic', local: @topics, layout: false
  end

  def articles
  	@day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)
    @articles = @topics.first().articles.order('published_at DESC').first(4)
    @articles_per_page = 4
    @total_articles = (@topics.first().articles.count / 4.to_f).ceil
    render partial: 'topics/article', local: @articles, layout: false
  end

  def popularity
  	@day = Day.where(date: params[:date]).first
    @topics = @day.topics
  	@popularities = Popularity.where(topic_id: @topics.first.id)
    render json: Popularity.popularitiesAsJSON(@popularities)
  end
end
