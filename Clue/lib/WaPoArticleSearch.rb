require_relative "API_Control"

class WaPoArticleSearch < APIControl
  @@base_url = "http://api.washingtonpost.com/trove/v1/search?q="
  @@app_key = "27D7BE94-8E90-48AA-8BF0-4AF5D19C4F25"

  def initialize
    @processed_url = ""
  end

  def set_params(keywords)
    @processed_url = @@base_url + keywords.split(" ").join("+")
    @processed_url += "&key=" + @@app_key
  end

  def get_response
    parse_JSON(get_request)
  end
end

client = WaPoArticleSearch.new
client.set_params("minimum wage")
ap client.get_response
