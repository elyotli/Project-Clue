require_relative "../APIControl"
require_relative "../PopularitySearch"
require "date"

class NYTArticleSearch < APIControl
  @@base_url = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  @@app_key = "295f07d2db55fce19a6bdd330412d2ff:0:70154133"
  @@followers = 14

  def initialize
    @processed_url = ""
  end

  def set_params(keywords, begin_date, sort_method)
    @processed_url = @@base_url + "q=" + keywords.split(" ").join("+")
    @processed_url += "&begin_date=" + begin_date
    @processed_url += "&api-key=" + @@app_key
  end

  def get_response
    response = parse_JSON(get_request)["response"]
    articles = []
    response["docs"].each do |item|
      articles << create_article(item)
    end
    return articles
  end

  def create_article(article_json)
    article = Story.new
    article.title = article_json["headline"]["main"]
    article.url = article_json["web_url"]
    article.abstract = article_json["abstract"]
    article.source = article_json["source"]
    popularity_client = PopularitySearch.new
    popularity_client.set_params(article.url)
    article.twitter_popularity = popularity_client.get_twitter_popularity/@@followers
    article.facebook_popularity = popularity_client.get_facebook_popularity

    # if article_json["multimedia"].length > 0 #you suck nyt
    #   article.image_url = "http://graphics8.nytimes.com/" + article_json["multimedia"][1]["url"]
    # else
    #   article.image_url = ""
    # end
     # to pull a smaller image, change the multimedia index 0
    article.published_at = article_json["pub_date"]
    return article
  end
end

# t = time.now()
# begin_date = t.year
# keyword = ["minimum wage"]
# all_articles = {}
# keyword.each do |keyphrase|
#   all_articles[keyphrase] = []
#   client = NYTArticleSearch.new
#   time_spam_nyt = Date.today.prev_day.strftime.gsub(/-/, "")
#   client.set_params(keyphrase, time_spam_nyt, "newest")
#   all_articles[keyphrase] += client.get_response
# end
# ap "All Articles: #{all_articles}"
