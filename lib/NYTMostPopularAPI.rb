require_relative "APIControl"

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
    "all"=> "/all-sections"
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
    key_words = []
    ap results
    results.each do |result|
      # p result["des_facet"]
      key_words += result["des_facet"] unless result["des_facet"] == ""
      key_words += result["per_facet"] unless result["per_facet"] == ""
      key_words += result["org_facet"] unless result["org_facet"] == ""
      key_words += result["geo_facet"] unless result["geo_facet"] == ""
    end
    key_words
  end

  def get_response
    parse_response(parse_JSON(get_request))
  end
end

client = NYTMostPopularAPI.new
client.set_params("share", "all", "1")
ap client.get_response

