require_relative "API_control"

class GoogleTrendsClient < APIControl
  @@base_url = "http://www.google.com/trends/fetchComponent?hl=en-US&cmpt=q&content=1&export=3&cid=TIMESERIES_GRAPH_0"

  def initialize
    @processed_url = ""
  end
  # past 3 months
# &date=today+3-m

  def set_params(keywords, day_span)
    @processed_url = @@base_url
    @processed_url += "&q=" + keywords.split(" ").join("+")
    @processed_url += "&date=today+" + day_span + "-d"
  end

  def get_response
    p @processed_url
    response = get_request
  end

end


query_option = {
  time_series: "&TIMESERIES_GRAPH_0",
  related_search: "&RISING_QUERIES_0_0"
}

# jan 2014 to sept 2014
# &date=1/2014+9m

# past 3 months
# &date=today+3-m

client = GoogleTrendsClient.new
client.set_params("minimum wage", "7")
ap client.get_response