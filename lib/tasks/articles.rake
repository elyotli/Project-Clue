Dir["./lib/article_search/API/*"].each {|file| require file }
Dir["./lib/article_search/RSS/*"].each {|file| require file }

namespace :topics do
  desc "find articles"
  task :get_articles => :environment do
    today = Day.find_or_create_by(date: Date.today)
    topics = today.topics.map{|topic| topic.title}

    NEWS_SOURCES = initialize_sources

    topics.each do |topic|
      articles = search_articles(topic, NEWS_SOURCES)
      articles = filter_articles(articles)
      ap [topic, articles]
      seed_articles(topic, articles)
    end
  end
end

def search_articles(topic, news_sources)
  articles = []
  news_sources.each do |source|
    p "searching for #{topic} in #{source.class}"
    articles += source.search(topic)
  end
  return articles
end
