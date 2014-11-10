  require_relative "../APIControl"
  require_relative "../PopularitySearch"


class GuardianArticleSearch < APIControl
  @@base_url = "http://content.guardianapis.com/search?"
  @@app_key = "sfrv3wukd7uaw7amha8cd2e6"
  @@followers = 2.8

  def initialize
    @processed_url = ""
  end

  def set_params(keywords, sort_method, count)
    @processed_url = @@base_url + "api-key=" + @@app_key
    @processed_url += "&q=" + keywords.split(" ").join("%20")
    @processed_url += "&order-by" + sort_method
    @processed_url += "&page-size=" + count
  end

  def get_response
    response = parse_JSON(get_request)
    articles = []
    # ap response["response"]["results"]
    response["response"]["results"].each do |item|
      articles << create_article(item)
    end
    return articles
  end

  def create_article(article_json)
    article = Story.new
    article.title = article_json["webTitle"]
    article.url = article_json["webUrl"]
    article.abstract = ""
    article.source = "TheGuardian"
    article.image_url = ""
    article.published_at = article_json["webPublicationDate"]
    popularity_client = PopularitySearch.new
    popularity_client.set_params(article.url)
    article.twitter_popularity = popularity_client.get_twitter_popularity/@@followers
    article.facebook_popularity = popularity_client.get_facebook_popularity
    return article
  end
end

# t = time.now()
# begin_date = t.year

# client = GuardianArticleSearch.new
# client.set_params("minimum wage", "newest", "20")
# ap client.get_response
