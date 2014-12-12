class TopicsController < ApplicationController
  def index
    @topics = Topic.last(5)
    @current_topic = @topics[1]
    @articles = @current_topic.articles
    gon.current_topic = @current_topic #gon passes variables from rails to javascript
  end

  def trends
    if request.xhr?
      topic_title = params[:topic].gsub(/-/, " ")
      current_topic = Topic.find_by(title: topic_title)
      if current_topic #if the topic is found
        dates = current_topic.popularities.map{|p| p.day.date}
        mindate = dates[0]
        maxdate = dates[-1]
        trends = current_topic.popularities.map{|p| p.google_trend_index}
        render :json => {status: 200, dates: [mindate, maxdate], trends: trends}
      else #if the topic doesn't exist in the db
        render :json =>  {status: 404}
      end
    end
  end

  def articles
    if request.xhr?
      topic_title = params[:topic].gsub(/-/, " ")
      current_topic = Topic.find_by(title: topic_title)
      if current_topic #if the topic is found
        @articles = current_topic.articles
        return render partial: "articles", collection: @articles, layout: false
      else #if the topic doesn't exist in the db
        render :json =>  {status: 404}
      end
    end

  end
end

