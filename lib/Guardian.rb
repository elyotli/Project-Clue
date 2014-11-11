
require "./../Requests_and_Responses"
require 'awesome_print'
require 'json'


class Guardian
  GUARDIAN_BASE_URL = "http://content.guardianapis.com/search?"
  GUARDIAN_APP_KEY = "sfrv3wukd7uaw7amha8cd2e6"
  GUARDIAN_SEARCH_URL = "http://content.guardianapis.com/search?"
  attr_accessor :all_articles, :initial_articles, :searched_articles
  include Requests_and_Responses

  def initialize
    @initial_articles = {}
    @all_articles = []
    @searched_articles = []
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

  def search(keywords)
    url = GUARDIAN_SEARCH_URL + "api-key=" + GUARDIAN_APP_KEY + "&q=" + keywords.split(" ").join("%20") + "&order-bynewest&page-size=10"
    response = JSON.parse(get_request(url))["response"]["results"]
    response.each do |a|
      article = {
                :title => a["webTitle"],
                :pub_date => a["webPublicationDate"],
                :url => a["webUrl"],
                :source => "TheGuardian"
                }
      @searched_articles << article
    end
    return get_popularity(@searched_articles)
  end
end

# Driver Code:
keywords = ["Ebola", "Obama"]
guard = Guardian.new
keywords.each { |word| guard.search(word) }
ap guard.all_articles