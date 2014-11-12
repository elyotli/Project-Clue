# Use these within this file:
# require "./../GetKeywords"
# require "./../Requests_and_Responses"

# Use these when calling this from an external file:
require "./GetKeywords"
require "./Requests_and_Responses"

require 'awesome_print'
class WashPost
  attr_accessor :searched_articles
  WAPO_BASE_URL = "http://api.washingtonpost.com/trove/v1/search?q="
  WAPO_APP_KEY = "27D7BE94-8E90-48AA-8BF0-4AF5D19C4F25"
  include GetKeywords
  include Requests_and_Responses

  def initialize
    @searched_articles = []
  end

  def search(keywords)
    searched_articles = []
    url = WAPO_BASE_URL + keywords.split(" ").join("+") + "&key=" + WAPO_APP_KEY
    response = JSON.parse(get_request(url))["itemCollection"]["items"]
    response.each do |a|
      article = {
                :abstract => a["snippet"],
                :title => a["displayName"],
                :pub_date => a["published"],
                :url => a["url"],
                :source => "WaPo"
                }
      searched_articles << article
    end
    # return get_popularity(@searched_articles)
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
      if article[:url].include?("wprss=rss")
        article[:url].gsub!(/\?wprss.*/,"")
      end
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      article[:facebook_pop] = get_facebook_popularity(article[:url])

      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
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

# Driver Code:
# keywords = ["Ebola", "Obama"]
# wapo = WashPost.new
# keywords.each { |word| wapo.search(word) }
# ap wapo.all_articles
