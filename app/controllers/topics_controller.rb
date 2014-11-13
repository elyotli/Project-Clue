class TopicsController < ApplicationController
	def index

    params[:date_id] ? day = Day.find(params[:date_id]) : day = Day.get_today

    @day_str = day.date.to_s
    @day = day
    @topics = day.topics.first(4)

    @all_articles = @topics.first.articles.where(published_at: @day_str).order('published_at DESC')
    @articles = @all_articles.first(4)

    @articles_per_page = 4
    @total_articles = @all_articles.count
    @current_page = 1
    @total_pages = (@total_articles / 4.0).ceil
    @maxDay = Day.last().date.to_s
    @minDay = Day.first().date.to_s
    @dataset = Popularity.popularitiesAsJSON(@topics.first.popularities.first(30))
	end

  def splash
    today = Day.get_today      
    @topics = today.topics
    render "splash"
  end

  # when a user click on the topic image
  def articles_page
    articles_per_page = 4
    date = Day.find(params[:date_id]).date.to_s
    page = params[:page].to_i - 1
    @articles = Topic.find(params[:topic_id]).articles.where(published_at: date).order('published_at DESC').offset(page * articles_per_page).limit(4)
    @total_articles = Topic.find(params[:topic_id]).articles.where(published_at: date).count
    @total_pages = (@total_articles / 4.0).ceil
    @current_page = page + 1

    # @articles, @total_articles, @current_page, @total_page
    render partial: 'topics/article', layout: false
  end

  def popularity
    @popularities = Popularity.where(topic_id: params[:topic_id])
    render json: Popularity.popularitiesAsJSON(@popularities)
  end

  def articles
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)
    @articles = @topics.first().articles.order('published_at DESC').first(4)
    @articles_per_page = 4
    @total_articles = @topics.first().articles.count
    render partial: 'topics/article', layout: false
  end

  # handle d3 range selection
  def articles_range
    # after range is selected, and user clicked the bottom carousel
    if(params[:page])
      @page = params[:page].to_i
      @articles_set = JSON.parse(params[:articles_set])
      @total_articles = @articles_set.count
      @articles = @articles_set.slice(@page,4).map do |id|
        Article.find(id)
      end
      @total_pages = (@total_articles / 4.to_f).ceil
      @current_page = @page
    else #first time running it
      @page = 0
      @topic = Topic.find(params[:topic_id])
      dayMin = Day.find(params[:min]).date.to_s
      dayMax = Day.find(params[:max]).date.to_s
      @articles = @topic.articles.where(published_at: dayMin..dayMax)
      @total_articles = @articles.count
      @total_pages = (@total_articles / 4.to_f).ceil
      @articles = @articles.order('published_at DESC')
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

