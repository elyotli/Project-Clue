require_relative "../NewYorkTimes"
require_relative "../NewYorkTimesSearch"
require_relative "../WashPost"
require_relative "../USAToday"
require_relative "../Guardian"

desc "this is the fucking project right here"
task :get_topics => :environment do
  # save day

  today = Day.create!(date: Date.today)

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
  topics = ["Ebola", "genetic engineering", "mormon", "search and seizure", "net neutrality"]

  # save topics
  # save day-topics
  # topics.each do |topic|
  #   current_topic = Topic.create!(title: topic)
  #   DayTopic.create!(topic_id: current_topic.id, day_id: today.id)
  # end

  # run article-search on each topic:
  # nyt_search = NewYorkTimesSearch.new
  # SELECT * FROM Topics JOIN DayTopics WHERE topic.id = topic_id
  # Or just:

 #Food for thought
    # top_five_keywords = ["ebola", "obama", "ferguson"]
    # all_articles = {}
    # news_sources = [
    #   NewYorkTimes.new()
    #   WaPo.new(),
    #   Guardian.new(),
    #   Cnn.new(),
    #   Abc.new()
    # ]

    # top_five_keywords.each do |keyword|
    #   all_articles[keyword] = news_sources
    #     .map {|source| source.search(keyword) }
    #     .flatten
    #     .sort_by(&:twitter_popularity)
    #     .take(5)
    # end

    # all_articles

  news_sources = [NewYorkTimesSearch.new, WashPost.new, Guardian.new]

  todays_articles = {}
  topics.each do |topic|
    todays_articles[topic] = news_sources.map{ |source| source.search(topic) }
        # .flatten
        # .sort_by(&:twitter_popularity)
        # .take(5)
  end
  ap todays_articles

  # topics_today = today.topics

  # todays_articles.each do |topic, articles|
  #   articles.each {|article| Article.create!(title: article.title,
  #                                           abstract: article.abstract,
  #                                           url: article.url,
  #                                           source: article.source,
  #                                           twitter_popularity: article.twitter_popularity,
  #                                           facebook_popularity: article.facebook_popularity
  #                                           )}
  # end

end










  # save the articles
  # save article_topics




  # run google trends
  # save popularities

