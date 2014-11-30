require 'simple-rss'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'
require 'pry'
require './lib/assets/PopularitySearch'

class RSSProcesser
  include PopularitySearch

  def get_response(url)
    rss = SimpleRSS.parse(get_request(url))
    full_items = rss.channel.items
  end

  #search for a keyword in the title and abstract of all the articles in this RSS feed
  def article_search(keyword)
    matches = []
    @articles.each do |article|
      article[:abstract] = "" if article[:abstract] == nil
      title_searched = article[:title].downcase.include?(keyword.downcase)
      abstract_searched = article[:abstract].downcase.include?(keyword.downcase)
      if title_searched || abstract_searched
        matches << article        
      end
    end
    return matches
  end

  #convert unformatted article feeds into article objects
  def format(raw_articles)
    output = []
    raw_articles.each do |raw_article|
      article = {}
      article[:title] = raw_article[:title]
      article[:url] = raw_article[:guid]
      article[:abstract] = raw_article[:description]
      article[:published_at] = raw_article[:pubDate]
      article[:image_url] = raw_article[@image]
      if article[:image_url] == nil
        article[:image_url] = "http://shackmanlab.org/wp-content/uploads/2013/07/person-placeholder.jpg"
      end
      output << article
    end
    return output
  end

  #update the social media popularities
  #this is separated out to avoid making too many calls
  def update_popularity
    @articles.map! do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url]).to_i
      article[:facebook_popularity] = get_facebook_popularity(article[:url]).to_i
    end
  end

  private

  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end
end

