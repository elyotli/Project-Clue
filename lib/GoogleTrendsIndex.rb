require 'json'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'awesome_print'
require 'mechanize'

class GoogleTrendsClient
  attr_accessor :data_hash
  BASE_URL = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"

  QUERY_OPTION = {
    time_series: "&TIMESERIES_GRAPH_0",
    related_search: "&RISING_QUERIES_0_0"
  }

  OHYEAHIDID = {
    "January"=> 1,
    "February"=> 2,
    "March"=> 3,
    "April"=> 4,
    "May"=> 5,
    "June"=> 6,
    "July"=> 7,
    "August"=> 8,
    "September"=> 9,
    "October"=> 10,
    "November"=> 11,
    "December"=> 12
  }

  def initialize(keywords, month_span)
    @processed_url = BASE_URL
    @processed_url += "&q=" + keywords.split(" ").join("+")
    @processed_url += "&date=today+" + month_span + "-m"
  end

  def get_request
    uri = URI.parse(@processed_url)
    p @processed_url
    request = Net::HTTP::Get.new(uri)
    # feeding the cookie monster
    request['Cookie'] = "PREF=ID=15a0c35777e5d761:U=0406a7d45c556908:FF=0:LD=en:NR=100:TM=1414641345:LM=1415489465:GM=1:SG=2:S=8c1dQPRl7PMzJbmb"
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

  def process_data
    response = get_request
    filtered = response.match(/[(].*/).to_s
    filtered = filtered.gsub(/(new Date)\D\d{4}\D\d{1,2}\D\d{1,2}\D/)  { |s| s = '"' + s + '"' }
    filtered = filtered[1..-3]
    response_JSON = JSON.parse(filtered)
    @data_hash = build_objects(response_JSON)
  end

  def build_objects(response_JSON)
    data_hash = {}
    response_JSON["table"]["rows"].each do |row|
      cell = row["c"]
      datedata = parse_date(cell[0]["v"])
      indexdata = cell[1]["f"]
      if indexdata.nil?
        indexdata = 0
      else
        indexdata = indexdata.to_i
      end
      data_hash["#{datedata}"]= indexdata
    end
    return data_hash
  end

  def parse_date(raw_string)
    # input_array = raw_string.split(", ")
    # year = input_array[2].to_i
    # month_day = input_array[1].split(" ")
    # month = OHYEAHIDID[month_day[0]]
    # day = month_day[1].to_i
    # Date.new(year,month,day)

    date_array = raw_string[9..-1].split(",")
    p date_array
    year = date_array[0].to_i
    month = date_array[1].to_i + 1
    day = date_array[2].to_i
    Date.new(year,month,day)
  end

  def detect_trend(delta)
    trending_days = []
    previous_index = 100
    @data_hash.each do |k, v|
      if v - previous_index > delta
        trending_days << k
      else
      end
      previous_index = v
    end
    return trending_days
  end

end

# client = GoogleTrendsClient.new("midterm election", "3")
# #available month_span: 1, 3
# ap client.process_data
# ap client.detect_trend(15)

# mech_client1 = Mechanize.new
# mech_client1.get("http://www.google.com/")
# cookiejar = mech_client1.cookie_jar

# ap cookiejar.cookies
