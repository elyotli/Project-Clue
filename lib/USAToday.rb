
require "./../Requests_and_Responses"
require 'awesome_print'


class USAToday
  USATODAY_BASE_URL = "http://api.usatoday.com/open/articles?keyword="
  USATODAY_APP_KEY = "gc66vcg4q8v5bhbsbzz4evzy"
  attr_accessor :all_articles, :initial_articles
  include Requests_and_Responses

  def initialize
    @initial_articles = {}
    @all_articles = []
  end

  def search(keyword)
    results = JSON.parse(get_request(USATODAY_BASE_URL + keywords.split(" ").join("+") + "&count=10&most=read&encoding=json&api_key=" + USATODAY_APP_KEY)["response"])
    results.each do |a|
      article = {
                :title => a["webTitle"],
                :pub_date => a["pubDate"],
                :url => a["link"],
                :source => "www.usatoday.com"
                }
      @initial_articles << article
    end
    return get_popularity
  end


  def get_popularity
    @initial_articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      article[:facebook_pop] = get_facebook_popularity(article[:url])
      unless article[:twitter_pop] == nil || article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop] + article[:facebook_pop]
        @all_articles << article
      end
      return sort_by_pop
    end
  end

  def sort_by_pop
    @all_articles.sort_by!{ |article| article[:total_popularity] }
  end
end

# Driver Code:
# keywords = ["Ebola", "Obama"]
# guard = USAToday.new
# keywords.each { |word| guard.search(word) }
# ap guard.all_articles