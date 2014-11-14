require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'
# require './GetKeywords'

module Requests_and_Responses

  def hello
    puts "This is inside the Requests and Responses module."
    a = Article.new
  end

  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port){ |http| http.request request }
    return response.body
  end

  def get_twitter_popularity(url)
    article_twitter_popularity = JSON.parse(get_request("http://urls.api.twitter.com/1/urls/count.json?url=" + url.to_s))["count"]
  end

  def get_facebook_popularity(url)
    # p "http://graph.facebook.com/?id=" + url.to_s
    # p get_request("http://graph.facebook.com/?id=" + url.to_s)
    JSON.parse(get_request("http://graph.facebook.com/?id=" + url.to_s))["shares"]
  end

  # Specific to Guardian:
  # def get_response_guardian
  #   articles = []
  #   response = JSON.parse(get_request)
  #   response["response"]["results"].each do |item|
  #     new_article = create_guardian_article(item)
  #     articles << new_article
  #   end
  #   return articles # This should be an array of article objects
  # end

  # def create_guardian_article(article_json)
  #   article = Article.new
  #   article.title = article_json["webTitle"]
  #   article.url = article_json["webUrl"]
  #   article.abstract = ""
  #   article.source = "TheGuardian"
  #   article.image_url = ""
  #   article.published_at = article_json["webPublicationDate"]
  #   article.twitter_popularity = get_twitter_popularity(article.url)
  #   article.facebook_popularity = get_facebook_popularity(article.url)
  #   return article
  # end

  def get_response_nyt
    articles = []
    time_span = Date.today.prev_day.strftime.gsub(/-/, "")
    response = JSON.parse(get_request)["response"]
    response["docs"].each do |item|
      new_article = create_nyt_article(item)
      articles << new_article
    end
    return articles
  end

  # def create_nyt_article(article_json)
  #   article = Article.new
  #   article.title = article_json["headline"]["main"]
  #   article.url = article_json["web_url"]
  #   article.abstract = article_json["abstract"]
  #   article.source = article_json["source"]
  #   article.twitter_popularity = get_twitter_popularity(article.url)
  #   article.facebook_popularity = get_facebook_popularity(article.url)

  #   # if article_json["multimedia"].length > 0 #you suck nyt
  #   #   article.image_url = "http://graphics8.nytimes.com/" + article_json["multimedia"][1]["url"]
  #   # else
  #   #   article.image_url = ""
  #   # end
  #    # to pull a smaller image, change the multimedia index 0
  #   article.published_at = article_json["pub_date"]
  #   article.save
  # end
end

