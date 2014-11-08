require_relative "API_control"

class GuardianArticleSearch < APIControl
  @@base_url = "http://content.guardianapis.com/search?"
  @@app_key = "sfrv3wukd7uaw7amha8cd2e6"

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
    article = Article.new
    article.title = article_json["webTitle"]
    article.url = article_json["webUrl"]
    article.abstract = ""
    article.source = "TheGuardian"
    article.image_url = ""
    article.published_at = article_json["webPublicationDate"]
    return article
  end
end

# t = time.now()
# begin_date = t.year

client = GuardianArticleSearch.new
client.set_params("minimum wage", "newest", "20")
ap client.get_response
