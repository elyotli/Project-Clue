# Use these within this file:
# require "./../GetKeywords"
# require "./../Requests_and_Responses"

# Use these when calling this from an external file:
require "./GetKeywords"
require "./Requests_and_Responses"
require 'net/http'


require 'awesome_print'

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
  end

  def get_initial_articles
    @all_articles = []
    @initial_articles = get_keywords

    #gets rid of blog pieces
    @initial_articles.delete_if do |article| 
       article[:url].include? "blogs.nytimes"
     end 

     #gets rid of interactive videos that sometimes get returned
     @initial_articles.delete_if do |article| 
       article[:keywords].length < 1
     end 
    return get_popularity(@initial_articles)
  end

  def get_popularity(articles)
    articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      article[:facebook_pop] = get_facebook_popularity(article[:url])

      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
        @all_articles << article
      end
    end
    return sort_by_pop
  end

  def sort_by_pop
    sorted = @all_articles.sort_by!{ |article| article[:total_popularity] }
    @all_articles = sorted.reverse
  end
end


# Driver Code:
# nyt = NewYorkTimes.new
# nyt.get_initial_articles
