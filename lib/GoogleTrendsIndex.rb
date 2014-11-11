require 'json'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'awesome_print'
# require 'curb'

class GoogleTrendsClient
  BASE_URL = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"

  QUERY_OPTION = {
  time_series: "&TIMESERIES_GRAPH_0",
  related_search: "&RISING_QUERIES_0_0"
  }

  def initialize(keywords, month_span)
    @processed_url = @@base_url
    @processed_url += "&q=" + keywords.split(" ").join("+")
    @processed_url += "&date=today+" + month_span + "-m"
  end

  def get_request
    uri = URI.parse(@processed_url)
    request = Net::HTTP::Get.new(uri)
    # feeding the cookie monster
    request['Cookie'] = "PREF=ID=15a0c35777e5d761:U=0406a7d45c556908:FF=0:LD=en:NR=100:TM=1414641345:LM=1415489465:GM=1:SG=2:S=8c1dQPRl7PMzJbmb"
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  def get_response
    p @processed_url
    # response = get_request
  end

end

mech_client1 = Mechanize.new
mech_client1.get("http://www.google.com/")
cookiejar = mech_client1.cookie_jar

ap cookiejar.cookies
