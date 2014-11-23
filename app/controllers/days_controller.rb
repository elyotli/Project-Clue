class DaysController < ApplicationController
  def topics
    p params[:date]
    p "____________________________________________"
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)
    

    # @articles and @day are being used in the partial
   	render partial: 'topics/topic', local: @topics, layout: false
  end

  def articles
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)

    @all_articles = @topics.first().articles.where(published_at: @day.date.to_s).order('published_at DESC')
    @articles = @all_articles.first(4)

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
