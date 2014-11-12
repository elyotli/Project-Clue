class ArticlesController < ApplicationController
  def show
    @topic = Topic.find(params[:topic_id])
    @day = Day.find(params[:date_id])
    @articles = @topic.articles.where(published_at: @day.date)
    # @something = @articles.to_json
  end
end
