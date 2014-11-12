class TopicsController < ApplicationController
	def index
    params[:date_id] ? day = Day.find(params[:date_id]) : day = Day.first
    @day_str = day.date.to_s
    @day = day
    @topics = day.topics.first(4)
    @articles = @topics.first.articles.first(4)
    @dataset = Popularity.popularitiesAsJSON(@topics.first.popularities.first(30))
    @articles_per_page = 4
    @total_articles = @topics.first().articles.count
    @maxDay = Day.last().date.to_s
    @minDay = Day.first().date.to_s
	end

    def splash
      day = Date.today ||= Date.yesterday
        
        Day.where(date: Date.today)
        current_day = Day.all.sort_by{|day| day.date}.last
        @topics = today.topics



        render "splash", layout: false
    end

  def articles_page
    articles_per_page = 4
    date = Day.find(params[:date_id]).date.to_s
    page = params[:page].to_i - 1
    @articles = Topic.find(params[:topic_id]).articles.where(published_at: date).offset(page * articles_per_page).limit(4)
    @total_articles = Topic.find(params[:topic_id]).articles.where(published_at: date).count
    @total_pages = (@total_articles / 4.0).ceil
    @current_page = page + 1
    render partial: 'topics/article', layout: false
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
    render partial: 'topics/article', layout: false
  end

  def articles_range
    if(params[:page])
      @page = params[:page].to_i
      @articles_set = JSON.parse(params[:articles_set])
      @total_articles = @articles_set.count
      @articles = @articles_set.slice(@page,4).map do |id|
        Article.find(id)
      end
      @total_pages = (@total_articles / 4.to_f).ceil
      @current_page = @page
    else
      @page = 0
      @topic = Topic.find(params[:topic_id])
      dayMin = Day.find(params[:min]).date.to_s
      dayMax = Day.find(params[:max]).date.to_s
      @articles = @topic.articles.where(published_at: dayMin..dayMax)
      @total_articles = @articles.count
      @total_pages = (@total_articles / 4.to_f).ceil
      @articles = @articles.shuffle
      @articles_set = @articles.map do |article|
        article.id
      end
      @articles = @articles.slice(@page,4)
      @total_pages = (@total_articles / 4.to_f).ceil
      @current_page = @page
    end

    render partial: 'topics/articles_range', layout: false
  end

end

