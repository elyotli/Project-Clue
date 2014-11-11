
require "./../Requests_and_Responses"
require 'awesome_print'


class Guardian
  GUARDIAN_BASE_URL = "http://content.guardianapis.com/search?"
  GUARDIAN_APP_KEY = "sfrv3wukd7uaw7amha8cd2e6"
  attr_accessor :all_articles, :initial_articles
  include Requests_and_Responses

  def initialize
    @initial_articles = {}
    @all_articles = []
  end

  def search(keyword)
    results = JSON.parse(get_request(GUARDIAN_BASE_URL + "api-key=" + GUARDIAN_APP_KEY + "&q=" + keywords.split(" ").join("%20") + "&order-bynewest&page-size=10")["response"]["results"])
    results.each do |a|
      article = {
                :title => a["webTitle"],
                :pub_date => a["webPublicationDate"],
                :url => a["webURL"],
                :source => "TheGuardian"
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
# guard = Guardian.new
# keywords.each { |word| guard.search(word) }
# ap guard.all_articles