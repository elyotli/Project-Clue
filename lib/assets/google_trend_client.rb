module GoogleTrendClient

  BASE_URL = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"
  COOKIE = "PREF=ID=15a0c35777e5d761:U=0406a7d45c556908:FF=0:LD=en:NR=100:TM=1414641345:LM=1415489465:GM=1:SG=2:S=8c1dQPRl7PMzJbmb"

  def trend_search(keywords)
    response = get_request(keywords)
    parse_response(response)
  end

  def detect_peaks(trend_data)
    delta = trend_data.values.stdev 
    median = median(trend_data.values)
    trending_days = trend_data.select do |date, popularity|
      popularity - median > delta
    end.keys
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
    response = response.match(/[(].*/).to_s[1..-3]
    response = response.gsub(/(new Date)\D\d{4}\D\d{1,2}\D\d{1,2}\D/)  { |s| s = '"' + s + '"' }
    response = JSON.parse(response)
    unless response["status"] == "error"
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
end