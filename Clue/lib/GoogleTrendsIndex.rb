require_relative "API_control"
require 'rubygems'
require 'open-uri'
require 'nokogiri'
# require 'curb'

class GoogleTrendsClient < APIControl
  @@base_url = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"

  @@query_option = {
  time_series: "&TIMESERIES_GRAPH_0",
  related_search: "&RISING_QUERIES_0_0"
  }

  def initialize
    @processed_url = ""
  end

  def set_params(keywords, month_span)
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

# client = GoogleTrendsClient.new
# #available month_span: 1, 3
# client.set_params("minimum wage", "3")
# ap client.get_response


# c = Curl::Easy.perform("http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=5&cid=TIMESERIES_GRAPH_0&q=minimum+wage&date=today+3-m")
# puts c.body_str

