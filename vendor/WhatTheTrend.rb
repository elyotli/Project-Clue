require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

class OAuthClient
  attr_reader :credentials

  def initialize(credentials)
    # raise ArgumentError, "must provide consumer_key, consumer_secret, token, and token_secret" unless valid_credentials?(credentials)
    # @credentials = credentials
  end

  def get(url)
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

# sample usage:

client = OAuthClient.new(
    consumer_key: "25577021592c0c1a5dac2129c65ff1ea26c6bd3c"
)

ap client.get("http://api.whatthetrend.com/api/v2/trends.json?api-key=25577021592c0c1a5dac2129c65ff1ea26c6bd3c")

