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

# def filter_articles(articles)
#   #this isn't fair to more recent articles
#   popularity_cutoff = 50
#   articles.select do |article|
#     twitter_popularity(article[:url]) > popularity_cutoff
#   end
# end

# def seed_articles(topic, articles)
#   articles.each do |article|
#     a = Article.find_or_initialize_by(title: article[:title])
#     a.url = article[:url]
#     a.source = article[:source] unless article[:source] == nil
#     a.abstract = article[:abstract] unless article[:abstract] == nil
#     a.image_url = article[:image_url] unless article[:image_url] == nil
#     a.published_at = article[:published_at] unless article[:published_at] == nil
#     a.twitter_popularity = article[:twitter_pop] unless article[:twitter_pop] == nil
#     a.save!
#     top = Topic.find_by(title: topic)
#     at = ArticleTopic.find_or_create_by(article_id: a.id, topic_id: top.id)
#   end
# end

# def initialize_sources
#   sources = []
#   puts "initializing NYT"
#   sources << NYTArticleSearch.new
#   puts "initializing Guardian"
#   sources << GuardianArticleSearch.new
#   # puts "initializing ABC"
#   # sources << AbcNewsArticleSearch.new
#   # ABC takes forever
#   puts "initializing BBC"
#   sources << BbcNewsArticleSearch.new
#   puts "initializing CBS"
#   sources << CbsNewsArticleSearch.new
#   puts "initializing CNN"
#   sources << CNNArticleSearch.new
#   puts "initializing FOX"
#   sources << FoxNewsArticleSearch.new
#   puts "initializing NBC"
#   sources << NbcNewsArticleSearch.new
#   puts "initializing NPR"
#   sources << NprArticleSearch.new
#   puts "initializing Reuters"
#   sources <<ReutersArticleSearch.new
#   return sources
# end