class TopicsController < ApplicationController
	def index
    today = Day.last
    @topics = today.topics
	end

  def show
    @topic = Topic.find(params[:id])
  end
end

