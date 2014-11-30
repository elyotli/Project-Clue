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

      #initialize in case the result is blank
      des_facet = []
      org_facet = []
      per_facet = []
      des_facet = result["des_facet"] unless result["des_facet"] == ""
      org_facet = result["org_facet"] unless result["org_facet"] == ""
      per_facet = result["per_facet"] unless result["per_facet"] == ""

      # process parens
      des_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}
      org_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}
      per_facet.map! {|keyword| keyword.gsub(/\(.*\)/, "")}

      # process name
      per_facet.map! do |name|
        process_name(name)
      end

      parsed = des_facet + org_facet + per_facet

      #process space
      parsed.map!{|keyword| keyword.strip}

      ap parsed
      contender = {
                  :title => result["title"],
                  :abstract => result["abstract"],
                  :source => result["source"],
                  :keywords => parsed,
                  :url => result["url"]
                  }
      contenders << contender
    end

    return contenders
  end

  def process_name(name)
    name_array = name.split(",")
    last_name = name_array[0].strip
    if name_array[1].nil?
      return last_name
    else
      first_name = name_array[1].strip
      return first_name + " " + last_name
    end
  end
end