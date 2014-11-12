require_relative "../NewYorkTimes"
require_relative "../NewYorkTimesSearch"
require_relative "../WashPost"
require_relative "../USAToday"
require_relative "../Guardian"

desc "this is the fucking project right here"
task :get_topics => :environment do
  # save day

  today = Day.create!(date: Date.today)
  # today = Day.create!(date: Date.today.prev_day)

  # # NYT most popular tool
  # nyt = NewYorkTimes.new
  # articles = nyt.get_initial_articles # 100 articles from NYT
  # articles.each do |article|
  #   a = Article.new
  #   a.title = article[:title]
  #   a.url = article[:url]
  #   a.source = article[:source]
  #   a.twitter_popularity = article[:twitter_popularity]
  #   a.facebook_popularity = article[:facebook_popularity]
  # end

  # Filter the topics - Shomari
  # assuming these are the topics
  # topics = ["Ebola", "genetic engineering", "mormon", "search and seizure", "net neutrality"]
  topics = ["Veterans Day", "Vladimir Putin", "Loretta Lynch", "Ferguson", "Chinese"]

  topics.each do |topic|
    current_topic = Topic.create!(title: topic)
    DayTopic.create!(topic_id: current_topic.id, day_id: today.id)
  end

  news_APIs = [NewYorkTimesSearch.new, Guardian.new] #, WashPost.new]

  news_RSS = [AbcNewsArticleSearch.new, BbcNewsArticleSearch.new,
              CbsNewsArticleSearch.new, CNNArticleSearch.new,
              FoxNewsArticleSearch.new, NbcNewsArticleSearch.new,
              NprArticleSearch.new, ReutersArticleSearch.new]

  todays_articles = {}
  articles_to_save = {}
  topics.each do |topic|
    todays_articles[topic] = []
    todays_articles[topic] = news_APIs.map do |source|
      puts "Searching #{source}"
      source.search(topic)
    end.flatten
    todays_articles[topic] += news_RSS.map do |source|
      puts "Searching #{source}"
      source.search(topic)
    end
    todays_articles[topic].flatten!
    todays_articles[topic] = todays_articles[topic].sort_by{ |article| article[:twitter_pop] }.reverse
    articles_to_save[topic] = todays_articles[topic][0..8]
  end

  articles_to_save.each do |topic, articles|
    articles.each do |article|
      a = Article.new
      a.title = article[:title]
      a.url = article[:url]
      a.source = article[:source] unless article[:source] == nil
      a.abstract = article[:abstract] unless article[:abstract] == nil
      a.image_url = article[:image_url] unless article[:image_url] == nil
      a.published_at = today.date
      a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
      a.save!
      top = Topic.find_by(title: topic)
      at = ArticleTopic.create!(article_id: a.id, topic_id: top.id)
    end
  end
  # topics_today = today.topics

  # SEED STUFF FOR VIEW TESTING:
#   i = 6
#   while i <= 10 do
#     Popularity.create!(topic_id: i, day_id: Day.last.id, twitter_popularity: 300 + Random.rand(2700), facebook_popularity: 600 + Random.rand(5400), google_trend_index: 1 + Random.rand(99))
#     i += 1
#   end
# end


  # save the articles
  # save article_topics


  # run google trends
  # save popularities