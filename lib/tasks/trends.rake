require "../assets/GoogleTrendsClient"
require "../article_search/API/NYTArticleSearch"
require "../article_search/API/GuardianArticleSearch"
require "date"
require "pry"
require "awesome_print"
require "ruby-standard-deviation"

namespace :topics do
  desc "get trend data"
  task get_trends: :environment do
    # pull topics from DB
  	TIME_PERIOD = "3"
    today = Day.find_or_create_by(date: Date.today)
  	topics = today.topics.map{|topic| topic.title}

  	#pull the gtrends data for each topic
  	topics.each do |topic|
  		p "exploring #{topic} in google trends..."
  		client = GoogleTrendsClient.new(topic, TIME_PERIOD)
  		date_data_hash = client.process_data

  		date_data_hash.each do |k, v|
  			dbday = Day.find_or_create_by(date: Date.parse(k))
  			dbpop = Popularity.find_or_create_by(topic_id: dbtopic.id, day_id: dbday.id)
  			dbpop.google_trend_index = v
  			dbpop.save!
  		end
  		# ap date_data_hash
      unless date_data_hash == {}
  		  delta = date_data_hash.values.stdev
    		#find articles
    		breakout_dates = client.detect_trend(delta)
    		ap [topic, breakout_dates]
    		breakout_dates.each do |date_string|
    			seed_historical_articles(topic, date_string)
    		end
      end
  	end
  end
 end

 def seed_historical_articles(topic, date_string)
 	breakout_date = Date.parse(date_string)
 	dbday = Day.find_or_create_by(date: breakout_date)
 	dbtopic = Topic.find_or_create_by(title: topic)
 	article_results = NYTArticleSearch.new.search(topic, breakout_date)
  ap "historical articles for #{topic} : "
 	ap article_results


 	article_results.each do |article|
    unless article.nil?
   		a = Article.find_or_create_by(title: article[:title])
   		a.url = article[:url]
    	a.source = article[:source] unless article[:source] == nil
    	a.abstract = article[:abstract] unless article[:abstract] == nil
    	a.image_url = article[:image_url] unless article[:image_url] == nil
    	a.published_at = Date.parse(article[:published_at]) unless article[:image_url] == nil
    	a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
    	a.save!# unless article[:title] == nil
    	DayTopic.find_or_create_by(topic_id: dbtopic.id, day_id: dbday.id)
      ArticleTopic.find_or_create_by(topic_id: dbtopic.id, article_id: a.id)
    end
 	end
 end
