require_relative "../assets/GoogleTrendsClient"
require_relative "../assets/PopularitySearch"
require_relative "../article_search/API/NYTArticleSearch"
require_relative "../article_search/API/GuardianArticleSearch"
require "date"
require "pry"
require "awesome_print"
require "ruby-standard-deviation"

namespace :topics do
  desc "gets google trends data, save the data points, gets the historical articles"
  task get_trends: :environment do
    # pull topics from DB
    
  	TIME_PERIOD = "3"
    today = Day.find_or_create_by(date: Date.today)
  	topics = today.topics

  	topics.each do |topic|
  		p "searching #{topic.title} in google trends..."
      #still need to get the id of the topic
  		client = GoogleTrendsClient.new(topic.title, TIME_PERIOD)
  		trend_data = client.trend_data

      p "searching for the days that #{topic.title} is trending..."
      p trending_days = client.trending_days
      unless trending_days.nil?
        trending_days = filter_trending_days(topic, trending_days) 
        p "trending days that are new to the database"
        ap [topic.title, trending_days]

    		trending_days.each do |day|
    			articles = NYTArticleSearch.new.search(topic.title, day)
          articles += GuardianArticleSearch.new.search(topic.title, day)
          articles = filter_articles(articles)
          p "articles chosen:"
          ap articles
          seed_articles(topic, articles)
    		end
      end
      seed_popularity(topic, trend_data)
  	end
  end
end

#get rid of the historical days that we already searched 
def filter_trending_days(topic, trending_days)
  trending_days.select do |day|
    dbday_id = Day.find_by(date: day).id
    !Popularity.exists?(topic_id: topic.id, day_id:dbday_id)
  end
end

#find way to find articles that really matter
def filter_articles(articles)
  include PopularitySearch
  #this isn't fair to more recent articles
  popularity_cutoff = 200
  articles.each do |article|
    article[:twitter_pop] = twitter_popularity(article[:url])
  end
  articles.select do |article|
    article[:twitter_pop] > popularity_cutoff
  end
  articles = articles.sort_by{|article| article[:twitter_pop]}.reverse
  if articles.count > 3
    return articles[0..2]
  else
    return articles
  end
end

def seed_popularity(topic, trend_data)
  trend_data.each do |date, popularity|
    dbday = Day.find_or_create_by(date: date)
    dbpop = Popularity.find_or_create_by(topic_id: topic.id, day_id: dbday.id)
    dbpop.google_trend_index = popularity
    dbpop.save
  end
end

def seed_articles(topic, articles)
  articles.each do |article|
    a = Article.find_or_create_by(title: article[:title])
    a.url = article[:url]
    a.source = article[:source] unless article[:source] == nil
    a.abstract = article[:abstract] #mandatory
    a.image_url = article[:image_url] unless article[:image_url] == nil
    a.published_at = Date.parse(article[:published_at]) #mandatory, and sometimes published_at isn't a string
    a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
    a.save!
    dbday = Day.find_or_create_by(date: Date.parse(article[:published_at]))
    DayTopic.find_or_create_by(topic_id: topic.id, day_id: dbday.id)
    ArticleTopic.find_or_create_by(topic_id: topic.id, article_id: a.id)
  end
end