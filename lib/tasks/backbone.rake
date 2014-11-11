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

# topics.each {|topic| current_topic = Topic.create!(title: topic) }

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

  news_APIs = [NewYorkTimesSearch.new]

                  # Guardian.new,
                  # WashPost.new]

  news_RSS = [AbcNewsArticleSearch.new]
  # ,
  #             BbcNewsArticleSearch.new,
  #             CbsNewsArticleSearch.new,
  #             CNNArticleSearch.new,
  #             FoxNewsArticleSearch.new,
  #             NbcNewsArticleSearch.new,
  #             NprArticleSearch.new,
  #             ReutersArticleSearch.new]

  todays_articles = {}
  articles_to_save = {}
  topics.each do |topic|
    todays_articles[topic] = []
    todays_articles[topic] = news_APIs.map do |source|
      p "searching for #{topic} in #{source.class}"
      source.search(topic)
    end.flatten
    todays_articles[topic] += news_RSS.map do |source|
      # binding.pry
      source.search(topic)
    end

    todays_articles[topic].flatten!

    todays_articles[topic] = todays_articles[topic].sort_by{ |article| article[:twitter_pop] }.reverse
    articles_to_save[topic] = todays_articles[topic][0..3]

    # .flatten
    # .sort_by(&:twitter_popularity)
    # .take(5)
  end

  ap articles_to_save

  articles_to_save.each do |topic, articles|
    #key is the topic, v is the array of articles
    articles.each do |article|
      a = Article.new
      a.title = article[:title]
      a.url = article[:url]
      # a.source = article[:source]
      a.abstract = article[:abstract]
      # a.image_url = article[:image_url]
      a.published_at = Date.today
      a.twitter_popularity = article[:twitter_pop]
      a.save!
      top = Topic.find_by(title: topic)
      at = ArticleTopic.create!(article_id: a.id, topic_id: top.id)
    end
  end
  # topics_today = today.topics
end










  # save the articles
  # save article_topics




  # run google trends
  # save popularities

