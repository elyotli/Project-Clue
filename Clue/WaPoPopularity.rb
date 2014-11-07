require 'simple_oauth'
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

class WaPoPopularity
  def getArticles(topic, yyyymmdd)
      #NYTimesSearch(topic, yyyymmdd)
      WaPo(topic)
      #USAToday(topic)
      #guardian(topic)
    end

    def getResponse(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request request
      end
      return parse_JSON(response.body)
    end


   def WaPo(topic)
      url = "http://api.washingtonpost.com/trove/v1/search?q=#{topic}&key=27D7BE94-8E90-48AA-8BF0-4AF5D19C4F25"  #is this saft to store key in the string like this?  Ask baker or alyssa
      getResponse(url)
    end


    private

    def parse_JSON(response)
      JSON.parse(response)
    end
  end


  test = WaPoPopularity.new
 ap test.getArticles("ebola", 20140606)
