# This file is no longer needed.
# Use the NewYorkTimes class instead.

require_relative "../APIControl"

class NYTMostPopularAPI < APIControl

  @@base_url = "http://api.nytimes.com/svc/mostpopular/v2"
  @@app_key = "25c2511fffb22160760720222857b846:6:70154133"
  @@resource_type = {
    "email"=> "/mostemailed",
    "share"=> "/mostshared",
    "view"=> "/mostviewed"
  }
  @@time_period = {
    "1"=> "/1",
    "7"=> "/7",
    "30"=> "/30"
  }
  @@section = {
    "all"=> "/all-sections",
    "serious" => "/world;us;politics;business;technology;science;health"
  }

  def initialize
    @processed_url = ""
  end

  def set_params(resource_type, section, time_period, offset="0")
    @processed_url = @@base_url + @@resource_type[resource_type]
    @processed_url += @@section[section]
    @processed_url += @@time_period[time_period]
    @processed_url += ".json?offset="+ offset
    @processed_url += "&api-key=" + @@app_key
    return @processed_url
  end

  def parse_response(response_hash)
    results = response_hash["results"]
    contenders = []

    results.each do |result|
      contender = {
      :key_words => result["adx_keywords"].split(";"),
      :url => result["url"]
    }
    contenders << contender
    end
    # key_words.flatten
    return contenders
  end

  def get_response
    parse_response(parse_JSON(get_request))
  end
end

# client = NYTMostPopularAPI.new
# client.set_params("view", "all", "1")
# ap client.get_response
