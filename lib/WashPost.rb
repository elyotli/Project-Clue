
require "./../Requests_and_Responses"
require 'awesome_print'


class USAToday
  WAPO_BASE_URL = "http://api.washingtonpost.com/trove/v1/search?q="
  WAPO_APP_KEY = "27D7BE94-8E90-48AA-8BF0-4AF5D19C4F25"
  attr_accessor :all_articles, :initial_articles
  include Requests_and_Responses

  def initialize
    @initial_articles = {}
    @all_articles = []
  end

  def search(keyword)
    results = JSON.parse(get_request(WAPO_BASE_URL + keywords.split(" ").join("+") + WAPO_APP_KEY)["itemCollection"]["items"])
    results.each do |a|
      article = {
                :title => a["displayName"],
                :pub_date => a["published"],
                :url => a["url"],
                :source => a["source"]["displayName"]
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
# wapo = WashPost.new
# keywords.each { |word| wapo.search(word) }
# ap wapo.all_articles