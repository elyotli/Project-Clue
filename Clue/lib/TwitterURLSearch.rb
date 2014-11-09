require_relative "API_Control"
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'


class TwitterURLSearch < APIControl
  @@base_url = "http://urls.api.twitter.com/1/urls/count.json?url="

  def initialize
    @processed_url = ""
  end

  def set_params(url)
    @processed_url = @@base_url + url
  end

  def get_response
    parse_JSON(get_request)#["count"]
  end
end

# puts "*" * 30
# client = TwitterURLSearch.new

# client.set_params("mm4a.org/1wA1qCl")
# ap client.get_response
# puts "*" * 30
# puts "*" * 30
# client2 = TwitterURLSearch.new
# client2.set_params("http://www.nytimes.com/2014/11/07/opinion/paul-krugman-triumph-of-the-wrong.html")
# ap client2.get_response
# puts "*" * 30
