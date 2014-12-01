require "./lib/assets/PopularitySearch"
require 'pry'
require 'json'
require 'date'
require 'awesome_print'
require_relative 'APIProcesser'

class NYTArticleSearch < APIProcesser
  include PopularitySearch

  attr_reader :articles

  NYT_APP_KEY = "295f07d2db55fce19a6bdd330412d2ff:0:70154133"
  NY_BASE_SEARCH_URL = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  POPULARITY_CUTOFF = 100

  def initialize(keywords, lookup_date=Date.today)
    response =  get_request(keywords, lookup_date)
    @articles = format(response)
                update_popularity
                sort_by_popularity
                filter_by_popularity
  end

  def get_request(keywords, lookup_date)
    begin_date = lookup_date.prev_day.strftime.gsub(/-/, "")
    end_date = lookup_date.strftime.gsub(/-/, "")
    # http://api.nytimes.com/svc/search/v2/articlesearch.json?q=Ebola&begin_date=20141110&api-key=295f07d2db55fce19a6bdd330412d2ff:0:70154133
    url = NY_BASE_SEARCH_URL + "q=" + keywords.split(" ").join("+") + "&begin_date=" + begin_date + "&end_date=" + end_date + "&api-key=" + NYT_APP_KEY
    return JSON.parse(get_request(url))["response"]["docs"]
  end

  def format(response)
    articles = []
    response.each do |item|
      article = { title: item["headline"]["main"],
                  url: item["web_url"],
                  abstract: item["snippet"],
                  published_at: item["pub_date"],
                  source: "New York Times"
                }
      if item["multimedia"].length < 2
        article[:image_url] = "http://blog.mpp.org/wp-content/uploads/2014/01/New-York-Times-Logo.png"
      else
        article[:image_url] = "http://static01.nyt.com/" + item["multimedia"][1]["url"]
      end
      articles << article
    end
    return articles
  end
end