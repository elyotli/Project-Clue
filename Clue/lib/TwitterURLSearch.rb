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
client.set_params("http://trove.com/me/content/QmcWA")
p client.get_response
client.set_params("washingtonpost.com/voters-dont-seem-to-view-the-minimum-wage-as-a-partisan-political-issue/")
p client.get_response

client.set_params("google")
p client.get_response

