class TopicsController < ApplicationController
  include GoogleTrendClient

  respond_to :json

  def index
    @topics = Topic.all
  end

  def trends
    topic = Topic.find_or_initialize_by(name: params[:topic])
    NYTArticleSearch.new.search(topic.name, Date.today.prev_month, Date.today)
    
    if topic.persisted?
      respond_with topic.popularities
    else
      trend_data = trend_search(topic.name)
      topic.save!
      Popularity.save_data(topic.id, trend_data) if trend_data

      respond_with topic.popularities
    end
  end

  private

  def topic_params
    params.require(:topic)
  end 

end