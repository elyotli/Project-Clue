# require './Requests_and_Responses'
require 'awesome_print'

module GetKeywords

  def get_keywords
    return get_contenders
    # num_keywords = 5
    # top_keywords = keywords[0..(num_keywords - 1)]
    # return top_keywords
  end

  def get_contenders
    base_url = "http://api.nytimes.com/svc/mostpopular/v2"
    app_key = "25c2511fffb22160760720222857b846:6:70154133"
    resource_type = {"email"=> "/mostemailed",
                      "share"=> "/mostshared",
                      "view"=> "/mostviewed"
                    }
    time_period = {"1"=> "/1",
                    "7"=> "/7",
                    "30"=> "/30"
                  }
    section = { "all" => "/all-sections",
                "serious" => "/world;us;politics;business;technology;science;health"}

    results = []
    offset = 0
    while offset < 90
      processed_url = base_url + resource_type["view"] + section["serious"] + time_period["1"] + ".json?offset=" + offset.to_s + "&api-key=" + app_key
      results += JSON.parse(get_request(processed_url))["results"]
      offset += 20
    end

    # results.each do |result|
    #   create_nyt_article(result)
    # end

    contenders = []
    results.each do |result|
      contender = {
                  :title => result["title"],
                  :abstract => result["abstract"],
                  :source => result["source"],
                  :keywords => result["adx_keywords"].split(";"),
                  :url => result["url"]
                  }
      contenders << contender
    end

    return contenders
  end
end