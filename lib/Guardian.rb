# Use these within this file:
# require "./../GetKeywords"
# require "./../Requests_and_Responses"

# Use these when calling this from an external file:
require "./GetKeywords"
require "./Requests_and_Responses"

require 'awesome_print'
require 'json'
require 'date'
require 'pry'

class Guardian
  GUARDIAN_BASE_URL = "http://content.guardianapis.com/search?"
  GUARDIAN_APP_KEY = "sfrv3wukd7uaw7amha8cd2e6"
  GUARDIAN_SEARCH_URL = "http://content.guardianapis.com/search?"
  GUARDIAN_FROM_DATE = Date.today.prev_day.strftime('%Y-%m-%d')


  attr_accessor :all_articles, :initial_articles, :searched_articles
  attr_reader :followers
  include Requests_and_Responses

  def initialize
    @searched_articles = []
    search = TwitterWordSearch.new
    @followers = search.get_follower_count("guardian")/1000000
  end

  def get_popularity(articles)
    articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url]).to_i/followers
      # article[:facebook_pop] = get_facebook_popularity(article[:url])
      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
      end
    end
    return sort_by_pop
  end

  def sort_by_pop
    sorted = @searched_articles.sort_by!{ |article| article[:total_popularity] }
    @searched_articles = sorted.reverse
    return @searched_articles
  end

  def search(keywords)
    searched_articles = []
    url = GUARDIAN_SEARCH_URL + "api-key=" + GUARDIAN_APP_KEY + "&show-fields=main" + "&q=" + keywords.split(" ").join("%20") + "&from-date=" + GUARDIAN_FROM_DATE
    response = JSON.parse(get_request(url))["response"]["results"]
    response.each do |a|

       a["fields"] ||= "http://www.thehaasbrothers.com/hsite/wp-content/uploads/2014/04/guardian-logo.jpeg"
      article = {
                :title => a["webTitle"],
                :published_at => Date.parse(a["webPublicationDate"]),
                :url => a["webUrl"],
                :image_url => /http.*jpe?g/.match(a["fields"]["main"]).to_s,
                :source => "TheGuardian"

                }

                if article[:image_url] == ""
                  article[:image_url] = "http://www.thehaasbrothers.com/hsite/wp-content/uploads/2014/04/guardian-logo.jpg"
                end


      searched_articles << article
    end
    searched_articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])/followers
      unless article[:twitter_pop] == nil && article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop].to_i + article[:facebook_pop].to_i
      end
    end
    sorted = searched_articles.sort_by!{ |article| article[:total_popularity] }
    sorted.reverse!
    return p sorted
  end
end


# keywords = ["obama"]
# guard = Guardian.new
# keywords.each { |word| guard.search(word) }
# ap guard.all_articles
