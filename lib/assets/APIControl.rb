require 'uri'
require 'net/http'
require 'awesome_print'

class APIControl

  def get_request
    uri = URI.parse(@processed_url)
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

end