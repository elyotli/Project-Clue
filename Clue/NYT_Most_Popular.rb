require 'simple_oauth'
require 'uri'
require 'net/http'

class OAuthClient
  attr_reader :credentials

  def initialize(credentials)
    raise ArgumentError, "must provide consumer_key, consumer_secret, token, and token_secret" unless valid_credentials?(credentials)
    @credentials = credentials
  end

  def post(url)


    # create the HTTP post request
    uri = URI.parse(url)
    # request =  ** fill this in
    #hint - this request is going to need some form data (aka your tweet)

    # set the Authorization Header using the oauth helper
    request["Authorization"] = oauth_header(request)

    # connect to the server and send the request
    # response = ** fill this in

    return response
  end

  private

  # A helper method to generate the OAuth Authorization header given
  # an Net::HTTP::GenericRequest object and a Hash of params
  def oauth_header(request)
    SimpleOAuth::Header.new(request.method, request.uri, URI.decode_www_form(request.body), credentials).to_s
  end

  def valid_credentials?(credentials)
    [:consumer_key, :consumer_secret, :token, :token_secret].all? { |key| credentials[key] }
  end
end

# sample usage:

client = OAuthClient.new(
    consumer_key: "25c2511fffb22160760720222857b846:6:70154133"
)

p client.post("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=25c2511fffb22160760720222857b846:6:70154133").body