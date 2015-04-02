class TopicsController < ApplicationController

  
  def index
    @topics = Topic.all
  end

  def trends
    search params[:topic]

    respond_to do |format|
      format.json {}
    end
  end

  private

  def topic_params
    params.require(:topic)
  end

end

