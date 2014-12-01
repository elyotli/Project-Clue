require 'net/http'
require 'awesome_print'

class NewYorkTimes
  NYT_BASE_URL ="http://api.nytimes.com/svc/mostpopular/v2"
  NYT_APP_KEY = "295f07d2db55fce19a6bdd330412d2ff:0:70154133"
  NY_BASE_SEARCH_URL = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  attr_accessor :all_articles, :initial_articles, :searched_articles

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

  def get_contenders
    base_url = "http://api.nytimes.com/svc/mostpopular/v2"
    app_key = "25c2511fffb22160760720222857b846:6:70154133"
    resource_type = {"email"=> "/mostemailed",
                      "share"=> "/mostshared",
                      "view"=> "/mostviewed"
                    }
    time_period = {"1"=> "/1",
                    "7"=> "/7",
                    "30"=> "/30"
                  }
    section = { "all" => "/all-sections",
                "serious" => "/world;us;politics;business;technology;science;health"}

    results = []
    offset = 0
    while offset < 90
      processed_url = base_url + resource_type["view"] + section["serious"] + time_period["1"] + ".json?offset=" + offset.to_s + "&api-key=" + app_key
      results += JSON.parse(get_request(processed_url))["results"]
      offset += 20
    end

    contenders = []
    results.each do |result|

      #initialize in case the result is blank
      des_facet = []
      org_facet = []
      per_facet = []
      des_facet = result["des_facet"] unless result["des_facet"] == ""
      org_facet = result["org_facet"] unless result["org_facet"] == ""
      per_facet = result["per_facet"] unless result["per_facet"] == ""

      # process parens
      des_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}
      org_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}
      per_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}

      # process name
      per_facet.map! do |name|
        process_name(name)
      end

      parsed = des_facet + org_facet + per_facet

      #process space
      parsed.map!{|keyword| keyword.strip}

      ap parsed
      contender = {
                  :title => result["title"],
                  :abstract => result["abstract"],
                  :source => result["source"],
                  :keywords => parsed,
                  :url => result["url"]
                  }
      contenders << contender
    end

    return contenders
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
