require_relative "API_control"

class WaPoArticleSearch < APIControl
  @@base_url = "http://api.washingtonpost.com/trove/v1/search?q="
  @@app_key = "27D7BE94-8E90-48AA-8BF0-4AF5D19C4F25"

  def initialize
    @processed_url = ""
  end

  def set_params(keywords)
    @processed_url = @@base_url + keywords.split(" ").join("+")
    @processed_url += "&key=" + @@app_key
  end

  def get_response
    response = parse_JSON(get_request)
    articles = []
    response["itemCollection"]["items"].each do |item|
      articles << create_article(item)
    end
    return articles
  end

  def create_article(article_json)
    article = Article.new
    article.title = article_json["displayName"]
    article.url = article_json["url"]
    article.abstract = article_json["snippet"]
    article.source = article_json["source"]["displayName"]
    article.image_url = "WaPoIsLame"
    article.published_at = article_json["published"]
    return article
  end
end

client = WaPoArticleSearch.new
client.set_params("minimum wage")
ap client.get_response
