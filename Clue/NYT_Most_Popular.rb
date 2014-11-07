require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

class OAuthClient
  attr_reader :credentials

  def initialize(credentials)
    # raise ArgumentError, "must provide consumer_key, consumer_secret, token, and token_secret" unless valid_credentials?(credentials)
    # @credentials = credentials
  end

  def get(url)

    uri = URI.parse(url)
    p uri
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end

    return parse_JSON(response.body)
  end

  def getArticles(topic, yyyymmdd)
    #NYTimesSearch(topic, yyyymmdd)
    WaPo(topic)
    #USAToday(topic)
    #guardian(topic)
  end

  def getResponse(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end

    return parse_JSON(response.body)

  end

  def NYTimesSearch(topic, yyyymmdd)
    url = "http://api.nytimes.com/svc/search/v2/articlesearch.json?q#{topic}&begin_date=#{yyyymmdd}&api-key=295f07d2db55fce19a6bdd330412d2ff:0:70154133"
    getResponse(url)
  end

  def NYTimesMostPopular(today)

  end

  def WaPo(topic)
    url = "http://api.washingtonpost.com/trove/v1/search?q=#{topic}&key=27D7BE94-8E90-48AA-8BF0-4AF5D19C4F25"  #is this saft to store key in the string like this?  Ask baker or alyssa
    getResponse(url)
  end

  def USAToday(topic) #this has articles sorted by most read for whatever topic you pass in.  Put a count of 50 on
     url =  "http://api.usatoday.com/open/articles?tag=#{topic}&count=1&most=read&encoding=json&api_key=gc66vcg4q8v5bhbsbzz4evzy"
     getResponse(url)
  end

  def Hearst(topic)

  end

  def guardian(topic) #count is equal to 20, look for the size parameter
    url = "http://content.guardianapis.com/search?api-key=sfrv3wukd7uaw7amha8cd2e6&page-size=20&order-by=newest&q=#{topic}"
    response = getResponse(url)
    response["response"]["results"].each do |article|
      p article["webTitle"]
      p article["webUrl"]
      p article["webPublicationDate"]
      puts "\n"
    end
  end






  private

  def parse_JSON(response)
    JSON.parse(response)
  end
end



# sample usage:

client = OAuthClient.new(
    #consumer_key: "25c2511fffb22160760720222857b846:6:70154133" #most popular api key
     consumer_key: "295f07d2db55fce19a6bdd330412d2ff:0:70154133" #article search key
)

 ap client.getArticles("ebola", 20140606)

# ap client.get("http://api.nytimes.com/svc/search/v2/articlesearch.json?callback=svc_search_v2_articlesearch&fq=source%3A%28%22The+New+York+Times%22%29&begin_date=20141105&end_date=20141106&sort=newest&hl=true&page=1&api-key=295f07d2db55fce19a6bdd330412d2ff%3A0%3A70154133")

#trying to see if finding all articles and doing a twitter search against them is better than using keywords from the most popular articles and doing a twitter search againsit them

#goal- get keywords from the articles

#Wapo
#NYT
#hearst
#huffpost???
#USA Today
#guardian

#put in a topic
#get back an array of articles from each site going back 6 months.
#in one call



