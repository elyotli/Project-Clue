require 'net/http'

  def get_request
    uri = URI.parse("http://graph.facebook.com/?id=http://www.nytimes.com/2014/11/09/world/despite-cia-fears-thomas-mchale-port-authority-officer-kept-sources-with-ties-to-iran-attacks.html?hp&action=click&pgtype=Homepage&module=first-column-region&region=top-news&WT.nav=top-news&_r=0")
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    return response.body
  end

p get_request
