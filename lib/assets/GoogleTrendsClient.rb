require 'json'
require 'rubygems'
require 'uri'
require 'net/http'
require 'awesome_print'
require 'date'
require 'ruby-standard-deviation'
# require 'mechanize'

class GoogleTrendsClient
  attr_accessor :trend_data, :delta, :trending_days
  BASE_URL = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"
  COOKIE = "PREF=ID=15a0c35777e5d761:U=0406a7d45c556908:FF=0:LD=en:NR=100:TM=1414641345:LM=1415489465:GM=1:SG=2:S=8c1dQPRl7PMzJbmb"

  QUERY_OPTION = {time_series: "&TIMESERIES_GRAPH_0",
    related_search: "&RISING_QUERIES_0_0"}

  def search(keywords)
    response = get_request(keywords)
    @data = parse_response(response)
    @peaks = detect_peaks(@data)
  end

  private

  def get_request(keywords)
    processed_url ||= BASE_URL + "&q=" + keywords.split(" ").join("+")
    uri = URI.parse(processed_url)
    request = Net::HTTP::Get.new(processed_url)
    request['Cookie'] = COOKIE # feeding the cookie monster
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    response.body
  end

  def parse_response(response)
    if response["status"] != "error"
      response = response.match(/[(].*/).to_s
      response = response.gsub(/(new Date)\D\d{4}\D\d{1,2}\D\d{1,2}\D/)  { |s| s = '"' + s + '"' }
      response = JSON.parse(response[1..-3])
      trend_data = {}
      response["table"]["rows"].each do |row|
        datedata = parse_date(row["c"][0]["v"])
        indexdata = row["c"][1]["f"]
        indexdata = indexdata.nil? ? 0 : indexdata.to_i
        trend_data[datedata]= indexdata
      end
      return trend_data
    end
  end

  def detect_peaks(trend_data)
    unless trend_data == {}
      delta = trend_data.values.stdev 
      median = median(trend_data.values)
    end 
    trending_days = trend_data.select do |date, popularity|
      popularity - median > delta
    end.keys
  end

  def median(array)
    sorted = array.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def parse_date(raw_string)
    date_array = raw_string[9..-1].split(",")
    year = date_array[0].to_i
    month = date_array[1].to_i + 1
    day = date_array[2].to_i
    Date.new(year,month,day)
  end

  # def narrow_time_scope
  #   initial_relevant_date = @trending_days[0].prev_month.prev_month # get two months ahead
  #   year_from = initial_relevant_date.year
  #   month_from = initial_relevant_date.month
  #   day_difference = (Date.today - initial_relevant_date).to_i
  #   month_difference = (day_difference/30.4374).ceil #this is the average number of days in a month
  #   @processed_url += "&date=" + month_from.to_s + "/" + year_from.to_s + "+" + month_difference.to_s + "m"
  # end
end

# mech_client1 = Mechanize.new
# mech_client1.get("http://www.google.com/")
# cookiejar = mech_client1.cookie_jar

# ap cookiejar.cookies