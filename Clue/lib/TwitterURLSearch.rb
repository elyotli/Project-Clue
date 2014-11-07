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
    parse_JSON(get_request)["count"]
  end
end

client = TwitterURLSearch.new
client.set_params("http://www.nytimes.com/2014/11/07/us/politics/republican-wins-may-lead-to-fiscal-deal-with-democrats.html?hp&action=click&pgtype=Homepage&module=photo-spot-region&region=top-news&WT.nav=top-news")
p client.get_response
