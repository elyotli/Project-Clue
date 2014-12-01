require_relative "../assets/TwitterWordSearch"
require_relative "../assets/BingImageSearch"
require_relative "../assets/NewYorkTimesMostPopular"
Dir["../article_search/API/*"].each {|file| require file }
Dir["../article_search/RSS/*"].each {|file| require file }

namespace :topics do
  desc "get topics"
  task get_topics: :environment do
    #get nyt keywords
    topics = NewYorkTimesMostPopular.new.keywords
    news_sources = initialize_sources

    #check other news sources if they are cover the same keywords
    topic_coverage_hash = {}
    topics.each do |topic|
      topic_coverage_hash[topic] = crosscheck_references(topic, news_sources)
    end

    #give penalty on certain words
    topic_coverage_hash = apply_weighting(topic_coverage_hash)
    ap topic_coverage_hash
    topics = topic_coverage_hash.keys

    #topics save to DB
    topics[0..9].each do |topic|
      save_to_DB(topic)
    end
  end
end

def crosscheck_references(topic, news_sources)
  count = 0
  news_sources.each do |source|
    p "searching for #{topic} in #{source.class}"
    count += source.search(topic).count
  end
  return count
end

def apply_weighting(topic_coverage_hash)
  single_word_penalty = 0.7
  the_presidential_penalty = 0.6
  topic_coverage_hash.each do |k,v|
    if k == "BARACK OBAMA" #the presidential penalty
      topic_coverage_hash[k] = (v * the_presidential_penalty).floor
    elsif k.split(" ").length > 1 #if this is a multi word phrase
    else
      topic_coverage_hash[k] = (v * single_word_penalty).floor
    end
  end
  return topic_coverage_hash.sort_by{|k, v| v}.reverse
end

def save_to_DB(keyword)
  today = Day.find_or_create_by(date: Date.today)
  topic = Topic.find_or_create_by(title: keyword)
  topic.image_url = BingImageSearch.new(keyword).get_image_url
  topic.save
  daytopic = DayTopic.find_or_create_by(topic_id: topic.id, day_id: today.id)
end

def initialize_sources
  sources = []
  puts "initializing NYT"
  sources << NYTArticleSearch.new
  puts "initializing Guardian"
  sources << GuardianArticleSearch.new
  # puts "initializing ABC"
  # sources << AbcNewsArticleSearch.new
  puts "initializing BBC"
  sources << BbcNewsArticleSearch.new
  puts "initializing CBS"
  sources << CbsNewsArticleSearch.new
  puts "initializing CNN"
  sources << CNNArticleSearch.new
  puts "initializing FOX"
  sources << FoxNewsArticleSearch.new
  puts "initializing NBC"
  sources << NbcNewsArticleSearch.new
  puts "initializing NPR"
  sources << NprArticleSearch.new
  puts "initializing Reuters"
  sources <<ReutersArticleSearch.new
  return sources
end