require_relative '../../assets/PopularitySearch'

class APIProcesser
  include PopularitySearch

  def get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(url)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    puts response
    return response.body
  end

  def update_popularity(articles)
    @articles.map! do |article|
      article[:twitter_pop] = get_twitter_popularity(article[:url]).to_i
      article[:facebook_pop] = get_facebook_popularity(article[:url]).to_i
    end
  end

  def sort_by_popularity
    @articles.sort_by! do |article|
      article[:twitter_pop]
    end
    @articles.reverse!
  end

  def filter_by_popularity
    @articles = @articles.select do |article|
      article[:twitter_pop] > POPULARITY_CUTOFF
    end
  end

end