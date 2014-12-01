Dir["./lib/article_search/API/*"].each {|file| require file }
Dir["./lib/article_search/RSS/*"].each {|file| require file }

namespace :topics do
  desc "find articles"
  task :get_articles => :environment do

    today = Day.find_by(date: Date.today)

    topics = today.topics
    topics = topics.map{|topic| topic.title}

    # daringly put the method here
    news_sources = initialize_sources

    todays_articles = {}
    articles_to_save = {}
    topics.each do |topic|
      todays_articles[topic] = []
      todays_articles[topic] = news_APIs.map do |source|
        puts "Searching #{source}"
        source.search(topic)
      end.flatten
      todays_articles[topic] += news_RSS.map do |source|
        puts "Searching #{source} for #{topic}"
        source.search(topic)
      end
      todays_articles[topic].flatten!
      todays_articles[topic] = todays_articles[topic].sort_by{ |article| article[:twitter_pop] }.reverse
      articles_to_save[topic] = todays_articles[topic][0..8]
    end

    articles_to_save.each do |topic, articles|
      articles.each do |article|
        a = Article.find_or_initialize_by(title: article[:title])
        # a.title = article[:title]
        a.url = article[:url]
        a.source = article[:source] unless article[:source] == nil
        a.abstract = article[:abstract] unless article[:abstract] == nil
        a.image_url = article[:image_url] unless article[:image_url] == nil
        a.published_at = article[:published_at] unless article[:published_at] == nil
        a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
        a.save!
        top = Topic.find_by(title: topic)
        at = ArticleTopic.find_or_create_by(article_id: a.id, topic_id: top.id)
      end
    end
  end
end