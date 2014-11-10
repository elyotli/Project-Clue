require_relative "../API_control"
require_relative "../PopularitySearch"

def USAToday(topic) #this has articles sorted by most read for whatever topic you pass in.  Put a count of 50 on
     url =  "http://api.usatoday.com/open/articles?tag=#{topic}&count=50&most=read&encoding=json&api_key=gc66vcg4q8v5bhbsbzz4evzy"
     getResponse(url)
end


require_relative "../API_control"

class USATodayArticleSearch < APIControl
  @@base_url = "http://api.usatoday.com/open/articles?keyword="
  @@app_key = "gc66vcg4q8v5bhbsbzz4evzy"
  @@followers = 1.3

  def initialize
    @processed_url = ""
  end

  def set_params(keywords)
    @processed_url = @@base_url + keywords.split(" ").join("+")
    @processed_url += "&count=10&most=read&encoding=json"
    @processed_url += "&api_key=" + @@app_key
  end

  def get_response
    response = parse_JSON(get_request)
    # p response
    articles = []
    response["stories"].each do |item|
      articles << create_article(item)
    end
    return articles
  end

  def create_article(article_json)
    article = Story.new
    article.title = article_json["title"]
    article.url = article_json["link"]
    article.abstract = article_json["description"]
    article.source = "www.usatoday.com"
    article.image_url = "USAtodayIsLame"
    article.published_at = article_json["pubDate"]
    popularity_client = PopularitySearch.new
    popularity_client.set_params(article.url)
    article.twitter_popularity = popularity_client.get_twitter_popularity/@@followers
    article.facebook_popularity = popularity_client.get_facebook_popularity
    return article
  end
end

# client = USATodayArticleSearch.new
# client.set_params("Midterm Elections (2014)")
# ap client.get_response


# keywords = ["Global Warming", "United States", "Republican Party", "Midterm Elections (2014)", "Boehner, John A"]
# keywords = ["Global Warming", "United States"]
# all_articles = {}

# keywords.each do |keyphrase|
#   all_articles[keyphrase] = []
# usa_today = USATodayArticleSearch.new
#   usa_today.set_params(keyphrase)
#   all_articles[keyphrase] += usa_today.get_response
# end

# ap all_articles
