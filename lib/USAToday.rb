# Use these within this file:
# require "./../GetKeywords"
# require "./../Requests_and_Responses"

# Use these when calling this from an external file:
require "./GetKeywords"
require "./Requests_and_Responses"

require 'awesome_print'
require 'json'

class USAToday
  USATODAY_BASE_URL = "http://api.usatoday.com/open/articles?keyword="
  USATODAY_APP_KEY = "gc66vcg4q8v5bhbsbzz4evzy"
  attr_accessor :all_articles, :initial_articles, :searched_articles
  include Requests_and_Responses

  def initialize
    # @initial_articles = {}
    # @all_articles = []
    @searched_articles = []
  end

  def get_popularity(articles)
    articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      article[:facebook_pop] = get_facebook_popularity(article[:url])
      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
        # @all_articles << article
      end
    end
    return sort_by_pop
  end

  def sort_by_pop
    sorted = @searched_articles.sort_by{ |article| article[:total_popularity] }
    @searched_articles = sorted.reverse
  end

  def search(keyword)
    response = JSON.parse(get_request(USATODAY_BASE_URL + keyword.split(" ").join("+") + "&count=10&most=read&encoding=json&api_key=" + USATODAY_APP_KEY))["stories"]
    response.each do |a|
      article = {
                :title => a["title"],
                :pub_date => a["pubDate"],
                :url => a["link"],
                :source => "www.usatoday.com"
                }
      @searched_articles << article
    end
    return get_popularity(@searched_articles)
  end
end

# Driver Code:
# keywords = ["Ebola", "Obama"]
# usa_today = USAToday.new
# keywords.each { |word| usa_today.search(word) }
# ap usa_today.all_articles
