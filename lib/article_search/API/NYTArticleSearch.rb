require_relative 'APIProcesser'

class NYTArticleSearch < APIProcesser
  attr_reader :articles

  NYT_APP_KEY = "295f07d2db55fce19a6bdd330412d2ff:0:70154133"
  NY_BASE_SEARCH_URL = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  POPULARITY_CUTOFF = 100

  def search(query, begin_date, end_date)
    response = get_articles(query, begin_date, end_date)
    puts response
    parse_articles(response)
  end

  def get_articles(query, begin_date, end_date)
    b = begin_date.strftime.gsub(/-/, "")
    e = end_date.strftime.gsub(/-/, "")
    q = query.split(" ").join("+")
    url = NY_BASE_SEARCH_URL + "q=" + q + "&begin_date=" + b + "&end_date=" + e + "&api-key=" + NYT_APP_KEY
    JSON.parse(get_request(url))["response"]["docs"]
  end

  def parse_articles(response)
    @articles = []
    response.each do |item|
      article = { name: item["headline"]["main"],
                  url: item["web_url"],
                  abstract: item["snippet"],
                  published_at: item["pub_date"],
                  source: "New York Times"}
      # if item["multimedia"].length < 2
      #   article[:image_url] = "http://blog.mpp.org/wp-content/uploads/2014/01/New-York-Times-Logo.png"
      # else
      #   article[:image_url] = "http://static01.nyt.com/" + item["multimedia"][1]["url"]
      # end
      @articles << article
    end
    return @articles
  end
end