# Use these within this file:
# require "./../GetKeywords"
# require "./../Requests_and_Responses"

# Use these when calling this from an external file:
require "./GetKeywords"
require "./Requests_and_Responses"
require 'awesome_print'
require 'net/http'
require 'uri'
require 'pry'
require 'xmlsimple'

#5000 uses a month
class BingImageSearch
  BING_APP_KEY = "xj+2m63G35xFDggYpMP3vBzZzlKcHToIEFWV8U0gs6U  "
  # %27 is quotes, %20 is + 
  BING_IMAGE_BASE_URL = "https://api.datamarket.azure.com/Bing/Search/v1/Image?Market=%27en-US%27&Adult=%27Strict%27&ImageFilters=%27Size%3AMedium%2BAspect%3AWide%2BStyle%3APhoto%27&Query=%27"
  attr_accessor :url, :query
  include GetKeywords
  include Requests_and_Responses

  def initialize(query)
    @query = query
    url_format_query = query.split(" ").join("%20")
    @url = BING_IMAGE_BASE_URL + url_format_query
    @url += "%27"
  end

  def get_response
    uri = URI.parse(@url)
    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth '', BING_APP_KEY
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end
    XmlSimple.xml_in(res.body)
  end

  def get_image_url
    response = get_response
    response["entry"][1]["content"]["properties"][0]["MediaUrl"][0]["content"]
  end

end

# client = BingImageSearch.new("ebola virus")
# ap client.get_image_url
