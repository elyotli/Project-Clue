require_relative "../assets/GoogleTrendsClient"
require_relative "../assets/PopularitySearch"
require_relative "../article_search/API/NYTArticleSearch"
require_relative "../article_search/API/GuardianArticleSearch"
require "date"
require "pry"
require "awesome_print"
require "ruby-standard-deviation"

namespace :topics do
  desc "get trend data"
  task get_trends: :environment do
    # pull topics from DB
    include PopularitySearch
  	TIME_PERIOD = "3"
    today = Day.find_or_create_by(date: Date.today)
  	topics = today.topics.map{|topic| topic.title}

  	topics.each do |topic|
  		p "searching #{topic} in google trends..."
  		client = GoogleTrendsClient.new(topic, TIME_PERIOD)
  		data_hash = client.data_hash
      trending_days = client.trending_days

      ap [topic, trending_days]
  		data_hash.each do |k, v|
  			dbday = Day.find_or_create_by(date: Date.parse(k))
  			dbpop = Popularity.find_or_create_by(topic_id: dbtopic.id, day_id: dbday.id, google_trend_index: v)
  		end

  		trending_days.each do |day|
  			articles = NYTArticleSearch.new.search(topic, day)
        articles = filter_articles(articles)
        ap [topic, articles]
        seed_articles(topic, articles)
  		end
  	end
  end
end

def filter_articles(articles)
  #this isn't fair to more recent articles
  popularity_cutoff = 100
  articles.select do |article|
    twitter_popularity(article[:url]) > popularity_cutoff
  end
end

def seed_articles(topic, articles)
  dbtopic = Topic.find_by(title: topic)
  articles.each do |article|
    a = Article.find_or_create_by(title: article[:title])
    a.url = article[:url]
    a.source = article[:source] unless article[:source] == nil
    a.abstract = article[:abstract] unless article[:abstract] == nil
    a.image_url = article[:image_url] unless article[:image_url] == nil
    a.published_at = Date.parse(article[:published_at])
    a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
    a.save!
    Day.find_or_create_by(date: Date.parse(article[:published_at]))
    DayTopic.find_or_create_by(topic_id: dbtopic.id, day_id: dbday.id)
    ArticleTopic.find_or_create_by(topic_id: dbtopic.id, article_id: a.id)
  end
end