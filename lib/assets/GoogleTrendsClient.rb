require 'json'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'awesome_print'
require 'date'
# require 'mechanize'

class GoogleTrendsClient
  attr_accessor :trend_data, :delta, :trending_days
  BASE_URL = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"
  COOKIE = "PREF=ID=15a0c35777e5d761:U=0406a7d45c556908:FF=0:LD=en:NR=100:TM=1414641345:LM=1415489465:GM=1:SG=2:S=8c1dQPRl7PMzJbmb"

  QUERY_OPTION = {time_series: "&TIMESERIES_GRAPH_0",
    related_search: "&RISING_QUERIES_0_0"}

  def initialize(keywords, month_span)
    process_url(keywords, month_span)
    get_request
    parse_response
    build_data_hash
    detect_trends
  end

  def process_url(keywords, month_span)
    @processed_url = BASE_URL
    @processed_url += "&q=" + keywords.split(" ").join("+")
    @processed_url += "&date=today+" + month_span + "-m"
  end

  def parse_response
    @response = @response.match(/[(].*/).to_s
    @response = @response.gsub(/(new Date)\D\d{4}\D\d{1,2}\D\d{1,2}\D/)  { |s| s = '"' + s + '"' }
    @response = JSON.parse(@response[1..-3])
  end

  def build_data_hash
    @trend_data = {}
    # if no response
    if @response["status"] == "error"
      return @trend_data
    else
      @response["table"]["rows"].each do |row|
        cell = row["c"]
        datedata = parse_date(cell[0]["v"])
        indexdata = cell[1]["f"]
        if indexdata.nil?
          indexdata = 0
        else
          indexdata = indexdata.to_i
        end
        @trend_data[datedata]= indexdata
      end
    end
  end

  #the correct algorithm for peak detection that needs to be implemented
  # if the topic exist, look at the number of days since last time we looked at it its trends
    # use the correct trend timeline
    # take the ratio of an overlapping day
    # use that ratio on all previous days
  # if the topic is new
    # look at the longest span
    # look at the stdev of the curve until the next longest span and the next longest span
    # if the stdev is not significantly lower, keep this interval
    # else, we gotta repeat for the next longest span

  # then, look at the median and the standard deviation, any data above 1 stdev of the median should be captured
  # use the social media, ebola for sample data trials

  def detect_trends
    unless @trend_data == {}
      @delta = @trend_data.values.stdev 
      @median = calculate_median(@trend_data.values)
    end 
    @trending_days = @trend_data.select do |date, popularity|
      popularity - @median > @delta
    end.keys
  end

  private

  def calculate_median(array)
    sorted = array.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def get_request
    uri = URI.parse(@processed_url)
    # p @processed_url
    request = Net::HTTP::Get.new(uri)
    # feeding the cookie monster
    request['Cookie'] = COOKIE
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    @response = response.body
  end

  def parse_date(raw_string)
    date_array = raw_string[9..-1].split(",")
    year = date_array[0].to_i
    month = date_array[1].to_i + 1
    day = date_array[2].to_i
    Date.new(year,month,day)
  end
end

#client = GoogleTrendsClient.new("midterm election", "3")
#available month_span: 1, 3
#ap client.process_data
#ap client.detect_trend(15)

# mech_client1 = Mechanize.new
# mech_client1.get("http://www.google.com/")
# cookiejar = mech_client1.cookie_jar

# ap cookiejar.cookies
