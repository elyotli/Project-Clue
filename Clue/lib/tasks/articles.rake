require_relative "../TwitterWordSearch"
require_relative "../API_control"
require_relative "../article_search/NYTMostPopularAPI"
require_relative "../article_search/NYTArticleSearch"
require_relative "../article_search/GuardianArticleSearch"
require_relative "../article_search/USATodayArticleSearch"
require_relative "../article_search/WaPoArticleSearch"

namespace :articles do
  desc "get new articles and topics"
  task update_articles: :environment do
  require "Date"

    client = NYTMostPopularAPI.new
    client.set_params("view", "all", "1")
    # gets me today's keywords in all categories by most-viewed
    keywords_NYT = client.get_response

    num_keywords = 2
    top_keywords = keywords_NYT[0..(num_keywords - 1)]

    keywords_time_lapsed = {}
    keywords_retweets = {}

    top_keywords.each do |keyword|
      search = TwitterWordSearch.new
      search_result = search.search_tweet(keyword)
      keywords_time_lapsed[keyword] = search_result["time"]
      keywords_retweets[keyword] = search_result["retweets"]
    end

    #pull top 5 key, plug them into the article searches
    # use .keys on the resulting hash, like my_hash.keys[0..4]

    Hash[keywords_retweets.sort_by{|k, v| v}.reverse]
    top_five_keywords = keywords_retweets.keys[0..4]

    all_articles = {}
    top_five_keywords.each do |keyphrase|
      all_articles[keyphrase] = []

      nyt = NYTArticleSearch.new
      time_spam_nyt = Date.today.prev_day.strftime.gsub(/-/, "")
      nyt.set_params(keyphrase, time_spam_nyt, "newest")
      all_articles[keyphrase] += nyt.get_response

      usa_today = USATodayArticleSearch.new
      usa_today.set_params(keyphrase)
      all_articles[keyphrase] += usa_today.get_response

      wapo = WaPoArticleSearch.new
      wapo.set_params(keyphrase)
      all_articles[keyphrase] += wapo.get_response

      guardian = GuardianArticleSearch.new
      guardian.set_params(keyphrase, "newest", "10")
      all_articles[keyphrase] += guardian.get_response
    end
    ap all_articles
  end
end
