# require 'ArticleSearchModule'
require "./../GetKeywords"
require "./../Requests_and_Responses"
require 'awesome_print'
require 'Date'


class NewYorkTimes
  NYT_BASE_URL ="http://api.nytimes.com/svc/mostpopular/v2"
  NYT_APP_KEY = "295f07d2db55fce19a6bdd330412d2ff:0:70154133"
  NY_BASE_SEARCH_URL = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  attr_accessor :all_articles, :initial_articles, :searched_articles
  include GetKeywords
  include Requests_and_Responses

  def initialize
    @initial_articles = {}
    @all_articles = []
    @searched_articles = []
  end

  def get_initial_articles
    @initial_articles = get_keywords
    return get_popularity(@initial_articles)
  end

  def get_popularity(articles)
    articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      article[:facebook_pop] = get_facebook_popularity(article[:url])
      unless article[:twitter_pop] == nil || article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop] + article[:facebook_pop]
        @all_articles << article
      end
    end
    return sort_by_pop
  end

  def sort_by_pop
    sorted = @all_articles.sort_by!{ |article| article[:total_popularity] }
    @all_articles = sorted.reverse
  end

  def search(keyword)
    timespan = Date.today.prev_day.strftime.gsub(/-/, "")
    # p timespan
    url = NY_BASE_SEARCH_URL + "q=" + keyword.split(" ").join("+") + "&begin_date=" + timespan + "&api-key=" + NYT_APP_KEY
    # p url
    response = JSON.parse(get_request(url))["response"]
    # p response
    response["docs"].each do |item|
      article = { title: item["headline"]["main"],
                  url: item["web_url"],
                  abstract: item["abstract"],
                  source: item["source"]
                }
      @searched_articles << article
    end
    get_popularity(@searched_articles)
  end
end

# Driver Code:
# nyt = NewYorkTimes.new
# # ap nyt.get_initial_articles
# nyt.search("Chicago Bears")
# ap nyt.all_articles