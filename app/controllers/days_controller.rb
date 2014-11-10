class DaysController < ApplicationController
  def show
    @day = Day.where(date: params[:date]).first
    @topics = @day.topics.first(4)
    @articles = @topics.first().articles.first(4)
    @dataset = Popularity.popularitiesAsJSON(@topics.first.popularities.first(30))
    
    # tmp = render partial: 'topics/article', local: @articles, layout: false
    # stuff = 'this stuff!'
    render json: {tmp: 'tmp', stuff: 'stuff'}
  end
end
