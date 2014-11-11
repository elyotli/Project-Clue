# require 'ArticleSearchModule'
require "./../GetKeywords"
require "./../Requests_and_Responses"
require 'awesome_print'



class NewYorkTimes
  attr_accessor :all_articles, :initial_articles
  include GetKeywords
  include Requests_and_Responses

  def initialize
    @initial_articles = {}
    @all_articles = []
    get_initial_articles
    get_popularity
    sort_by_pop
  end

  def get_initial_articles
    @initial_articles = get_keywords
  end

  def get_popularity
    @initial_articles.each do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url])
      article[:facebook_pop] = get_facebook_popularity(article[:url])
      unless article[:twitter_pop] == nil || article[:facebook_pop] == nil
        article[:total_popularity] = article[:twitter_pop] + article[:facebook_pop]
        @all_articles << article
      end
    end
  end

  def sort_by_pop
    @all_articles.sort_by!{ |article| article[:total_popularity] }
  end

end

nyt = NewYorkTimes.new
ap nyt.all_articles