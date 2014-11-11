# Use these within this file:
# require "./../GetKeywords"
# require "./../Requests_and_Responses"

# Use these when calling this from an external file:
require "./GetKeywords"
require "./Requests_and_Responses"


require 'awesome_print'
# require 'Date'
class NewYorkTimesSearch
  attr_accessor :searched_articles

  NYT_APP_KEY = "295f07d2db55fce19a6bdd330412d2ff:0:70154133"
  NY_BASE_SEARCH_URL = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  include GetKeywords
  include Requests_and_Responses

  def initialize
    @searched_articles = []
  end

  def search(keyword)
    searched_articles = []
    timespan = Date.today.prev_day.strftime.gsub(/-/, "")
    url = NY_BASE_SEARCH_URL + "q=" + keyword.split(" ").join("+") + "&begin_date=" + timespan + "&api-key=" + NYT_APP_KEY
    response = JSON.parse(get_request(url))["response"]
    response["docs"].each do |item|
      article = { title: item["headline"]["main"],
                  url: item["web_url"],
                  abstract: item["abstract"],
                  source: item["source"]
                }
      searched_articles << article
    end
    # return get_popularity(searched_articles)
    searched_articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
      end
    end
    sorted = searched_articles.sort_by!{ |article| article[:total_popularity] }
    sorted.reverse!
    return sorted
  end

  def get_popularity(articles)
    articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      # article[:facebook_pop] = get_facebook_popularity(article[:url])

      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
        # @searched_articles << article
        # ap @searched_articles
      end
    end
    return sort_by_pop
  end

  def sort_by_pop
    sorted = @searched_articles.sort_by!{ |article| article[:total_popularity] }
    # @searched_articles = sorted.reverse
    return @searched_articles
  end
end

# nyt_search = NewYorkTimesSearch.new
# nyt_search.search("Ebola")
# ap nyt_search.searched_articles
