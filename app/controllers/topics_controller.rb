class TopicsController < ApplicationController
  include GoogleTrendClient

  respond_to :json

  def index
    @topics = Topic.all
  end

  def trends
    topic = Topic.find_or_initialize_by(name: params[:topic])
    if topic.persisted?
      puts topic.id
      respond_with @topic.popularities
    else
      topic.save!
      popularities = Popularity.save_data(topic, trend_search(params[:topic]))
      respond_with(popularities)
    end
  end

  private

  def topic_params
    params.require(:topic)
  end 

end