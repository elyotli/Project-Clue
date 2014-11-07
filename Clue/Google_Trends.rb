require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

class NYT_Most_Popular_Client
  attr_reader :app_key

  def initialize(key)
    @app_key = key
  end

  def get(url)
    url = url + @app_key unless url.include?(@app_key)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end

    return parse_JSON(response.body)
  end

  private

  def parse_JSON(response)
    JSON.parse(response)
  end
end

def parse_response(response_hash)
  results = response_hash["results"]
  key_words = []
  results.each do |result|

    key_words << result["adx_keywords"].split(";")
  end
  key_words.flatten
end

# driver-code:

APP_KEY = "25c2511fffb22160760720222857b846:6:70154133"

resource_type = {
  email:"mostemailed", 
  share: "mostshared", 
  view: "mostviewed"
  }

section = {all: "all-sections"}

client = NYT_Most_Popular_Client.new(APP_KEY)

response_hash = client.get("http://api.nytimes.com/svc/mostpopular/v2/" + resource_type[:view] + "/" + section[:all] + "/1.json?api-key=")

# ap parse_response(response_hash)