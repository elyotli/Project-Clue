require "./GetKeywords"
require "./Requests_and_Responses"
require_relative "./lib/TwitterWordSearch"
require 'awesome_print'
require 'active_record'
require './app/models/article'

ActiveRecord::Base.establish_connection({
  adapter:  'postgresql',
  database: 'Clue_development'
  # username: 'Clue',
  # password: "<%= ENV['CLUE_DATABASE_PASSWORD'] %>",
  # host:     'localhost'
})

class Alex
  include GetKeywords
  include Requests_and_Responses
  Article.connection

  def create_nyt_article(article_json)
    article = Article.new
    article.title = article_json[:title]
    article.url = article_json[:url]
    # article.abstract = article_json[:abstract]
    article.source = article_json[:source]
    # article.twitter_popularity = get_twitter_popularity(article.url)
    # article.facebook_popularity = get_facebook_popularity(article.url)

    # if article_json["multimedia"].length > 0 #you suck nyt
    #   article.image_url = "http://graphics8.nytimes.com/" + article_json["multimedia"][1]["url"]
    # else
    #   article.image_url = ""
    # end
     # to pull a smaller image, change the multimedia index 0
    # article.published_at = article_json["pub_date"]
    article.save!

  end
  # def get_twitter_popularity(url)
  #   article_twitter_popularity = JSON.parse(get_request("http://urls.api.twitter.com/1/urls/count.json?url=" + url))["count"]
  # end

  # def get_facebook_popularity(url)
  #   JSON.parse(get_request("http://graph.facebook.com/?id=" + url))["shares"]
  # end
end


a = Alex.new
contenders = a.get_keywords
# search = TwitterWordSearch.new

contenders.each do |article|
  a.create_nyt_article(article)
end


# keywords_time_lapsed = {}
# keywords_retweets = {}
# topics.each do |keyword|
#   search_result = search.search_tweet(keyword)
#   keywords_time_lapsed[keyword] = search_result["time"]
#   keywords_retweets[keyword] = search_result["retweets"]
# end

# puts keywords_time_lapsed
# puts keywords_retweets