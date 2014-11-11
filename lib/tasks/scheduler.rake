# Example scheduled rake task setup from Heroku:
#
# desc "This task is called by the Heroku scheduler add-on"
# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

# task :send_reminders => :environment do
#   User.send_reminders
# end

require_relative "../TwitterWordSearch"
require_relative "../APIControl"
require_relative "../article_search/NYTMostPopularAPI"
require_relative "../article_search/NYTArticleSearch"
require_relative "../article_search/GuardianArticleSearch"
require_relative "../article_search/USATodayArticleSearch"
require_relative "../article_search/WaPoArticleSearch"
require_relative "../article_search/RSSGrabber"

desc "get new articles and topics"
task :update_articles => :environment do
  require "awesome_print"

  Day.create(date: Date.today)

  client = NYTMostPopularAPI.new
  search = TwitterWordSearch.new
  client.set_params("view", "all", "1")
  keywords_NYT = client.get_response

  # number of keywords should be 15 in production:
  num_keywords = 5
  top_keywords = keywords_NYT[0..(num_keywords - 1)]

  keywords_time_lapsed = {}
  keywords_retweets = {}

  top_keywords.each do |keyword|
    search_result = search.search_tweet(keyword)
    keywords_time_lapsed[keyword] = search_result["time"]
    keywords_retweets[keyword] = search_result["retweets"]
  end

  # pull top 5 key, plug them into the article searches
  # use .keys on the resulting hash, like my_hash.keys[0..4]

  Hash[keywords_retweets.sort_by{|k, v| v}.reverse]
  top_five_keywords = keywords_retweets.keys[0..4].each {|topic| Topic.create(title: topic) }
  # top_five_keywords = top_keywords.slice(0,4)
  #To hardcode keywords:
  # top_five_keywords = ["ebola", "obama", "ferguson"]

  all_articles = {}
  top_five_keywords.each do |keyphrase|
    DayTopic.create!(topic_id: Topic.create!(title: keyphrase).id, day_id: Day.find_by(date: Date.today).id)
    all_articles[keyphrase] = []

    nyt = NYTArticleSearch.new
    time_spam_nyt = Date.today.prev_day.strftime.gsub(/-/, "")
    nyt.set_params(keyphrase, time_spam_nyt, "newest")
    all_articles[keyphrase] += nyt.get_response

    wapo = WaPoArticleSearch.new
    wapo.set_params(keyphrase)
    all_articles[keyphrase] += wapo.get_response

    guardian = GuardianArticleSearch.new
    guardian.set_params(keyphrase, "newest", "10")
    all_articles[keyphrase] += guardian.get_response
  end

  client = RSSGrabber.new
  cnn_top = client.get_response("http://rss.cnn.com/rss/cnn_topstories.rss")
  cnn_top_count = search.get_follower_count("cnn")/1000000
  cnn_top.each do |article|
    article["counts"] = cnn_top_count
  end

  reuters_top = client.get_response("http://feeds.reuters.com/reuters/topNews")
  reuters_top_count = search.get_follower_count("reuters")/1000000
  reuters_top.each do |article|
    article["counts"] = reuters_top_count
  end

  nbc_news_top = client.get_response("http://feeds.nbcnews.com/feeds/topstories")
  nbc_news_top_count = search.get_follower_count("NBCNews")/1000000
  nbc_news_top.each do |article|
    article["counts"] = nbc_news_top_count
  end


  abc_news_top = client.get_response("http://feeds.abcnews.com/abcnews/topstories")
  abc_news_top_count = search.get_follower_count("ABC")/1000000
  abc_news_top.each do |article|
    article["counts"] = abc_news_top_count
  end

  abc_count = search.get_follower_count("ABC")
  ap_top = client.get_response("http://hosted.ap.org/lineups/TOPHEADS.rss?SITE=AP&SECTION=HOME")
  ap_top_count =  search.get_follower_count("AP")/1000000
  ap_top.each do |article|
    article["counts"] = ap_top_count
  end

  npr_most = client.get_response("http://www.npr.org/rss/rss.php?id=100")
  npr_most_count = search.get_follower_count("nprnews")/1000000
  npr_most.each do |article|
    article["counts"] = npr_most_count
  end

  fox_news_most = client.get_response("http://feeds.foxnews.com/foxnews/most-popular")
  fox_news_most_count = search.get_follower_count("FoxNews")/1000000
  fox_news_most.each do |article|
    article["counts"] = fox_news_most_count
  end

  bbc_us_can = client.get_response("http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml")
  bbc_us_can.each do |article|
    article["counts"] = 5 #interesting case, don't know how to handle
  end

  cbs_news_top = client.get_response("http://www.cbsnews.com/latest/rss/main")
  cbs_news_top_count = search.get_follower_count("CBSNews")/1000000
  cbs_news_top.each do |article|
    article["counts"] = cbs_news_top_count
  end

  all_rss = []
  all_rss += cnn_top
  all_rss += reuters_top
  all_rss += nbc_news_top
  all_rss += abc_news_top
  all_rss += npr_most
  all_rss += fox_news_most
  all_rss += bbc_us_can

  rss_articles = []
  all_rss.each do |item|
    article = Story.new
    article.title = item[:title]
    article.url = item[:guid]
    article.abstract = item[:description].match(/.*[.][&]/).to_s
    article.published_at = item[:pubDate]
    popularity_client = PopularitySearch.new
    popularity_client.set_params(article.url)
    article.twitter_popularity = popularity_client.get_twitter_popularity/item["counts"]
    article.facebook_popularity = popularity_client.get_facebook_popularity
    rss_articles << article
  end

  rss_articles.each do |article|
    top_five_keywords.each do |keyphrase|
      all_articles[keyphrase] << article if article.title.downcase.include?(keyphrase.downcase) || article.abstract.downcase.include?(keyphrase.downcase)
    end
  end

  shown_articles = {}
  top_five_keywords.each do |keyword|
    all_articles[keyword].sort! {|a,b| b.twitter_popularity <=> a.twitter_popularity }
    shown_articles[keyword] = all_articles[keyword].slice(0, 5)
  end

  # top_five_keywords.each do |keyword|
  shown_articles.each do |keyword, articles|
    articles.each do |article|
      a = Article.create!(article)
      ArticleTopic.create!(topic_id: (Topic.find_by(title: keyword)).id, article_id: a.id)
    end
  end
end