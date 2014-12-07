require 'net/http'
require 'uri'
require 'awesome_print'

class NewYorkTimesMostPopular
  NYT_BASE_URL ="http://api.nytimes.com/svc/mostpopular/v2"
  NYT_APP_KEY = "25c2511fffb22160760720222857b846:6:70154133"

  RESOURCE_TYPE = {"email"=> "/mostemailed", "share"=> "/mostshared", "view"=> "/mostviewed"}
  SECTIONS = "/world;us;politics;business;technology;science;health"
  TIME_PERIOD = "/1" #past day
  attr_accessor :keywords

  def initialize
    get_top_articles
    filter_articles
    process_keywords
  end

  def get_top_articles
    @top_articles = []
    # get top 40 articles
    offset = 0
    while offset < 30
      @processed_url = NYT_BASE_URL + RESOURCE_TYPE["view"] + SECTIONS + TIME_PERIOD + ".json?offset=" + offset.to_s + "&api-key=" + NYT_APP_KEY
      @top_articles += JSON.parse(get_request(@processed_url))["results"]
      offset += 20
    end
  end

  def filter_articles
    #gets rid of blog pieces
    @top_articles.delete_if do |article| 
       article["url"].include? "blogs.nytimes"
    end
  end

  def process_keywords
    keyword_set = []
    @keywords = []
    @top_articles.each do |article|
      #initialize in case the article is blank
      des_facet = article["des_facet"] == "" ? [] : article["des_facet"]
      org_facet = article["org_facet"] == "" ? [] : article["org_facet"]
      per_facet = article["per_facet"] == "" ? [] : article["per_facet"]

      # formatting, get rid everything inside parens
      des_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}
      org_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}
      per_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}

      # process name
      per_facet.map! {|name| process_name(name)} 

      keyword_set = des_facet + org_facet + per_facet
      keyword_set.map!{|keyword| keyword.strip}

      #keywords_set should be stored somehow
      @keywords += keyword_set
    end
    @keywords.uniq!
  end

  private
  def get_request(processed_url)
    uri = URI.parse(processed_url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  #flip first and last name, changing "Obama, Barack" to "Barack Obama"
  def process_name(name)
    name_array = name.split(",")
    last_name = name_array[0].strip
    if name_array[1].nil?
      return last_name
    else
      first_name = name_array[1].strip
      return first_name + " " + last_name
    end
  end
end
