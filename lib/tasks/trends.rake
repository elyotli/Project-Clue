require "./Requests_and_Responses"
require "awesome_print"
require "./lib/GoogleTrendsIndex"
require "date"
require "pry"
require "./lib/NewYorkTimesSearch"
require "ruby-standard-deviation"

namespace :topics do
  desc "get trend data"
  task trends: :environment do
  	TIME_PERIOD = "3"

  	#pull today's topics
  	#save the data to popularity table

  	today = Day.find_or_create_by(date: Date.today)
  	topics = today.topics.map{|topic| topic.title}

  	# topics = ["potatoes"]
  	#pull the gtrends data for each topic
  	topics.each do |topic|
  		#save to DB
  		p "exploring #{topic}..."
  		dbtopic = Topic.find_or_create_by(title: topic)
  		client = GoogleTrendsClient.new(topic, TIME_PERIOD)
  		data_hash = client.process_data

  		data_hash.each do |k, v|
  			dbday = Day.find_or_create_by(date: Date.parse(k))
  			dbpop = Popularity.find_or_create_by(topic_id: dbtopic.id, day_id: dbday.id)
  			dbpop.google_trend_index = v
  			dbpop.save!
  			# data points before 30 days will be fucked up, but worry about that later
  		end
  		# ap data_hash
  		p delta = 1.5 * data_hash.values.stdev
  		#find articles
  		breakout_dates = client.detect_trend(delta)
  		ap [topic, breakout_dates]
  		breakout_dates.each do |date_string|
  			seed_historical_articles(topic, date_string)
  		end

  	end
  end
 end

 def seed_historical_articles(topic, date_string)
 	breakout_date = Date.parse(date_string)
 	dbday = Day.find_or_create_by(date: breakout_date)
 	dbtopic = Topic.find_or_create_by(title: topic)
 	article_results = NewYorkTimesSearch.new.search_with_date(topic, breakout_date)
 	ap article_results
 	article_results.each do |article|
 		a = Article.find_or_create_by(title: article[:title])
 		a.url = article[:url]
      	a.source = article[:source] unless article[:source] == nil
      	a.abstract = article[:abstract] unless article[:abstract] == nil
      	a.image_url = article[:image_url] unless article[:image_url] == nil
      	a.published_at = Date.parse(article[:published_at])
      	a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
      	a.save!
      	DayTopic.find_or_create_by(topic_id: dbtopic.id, day_id: dbday.id)
 	end
 end