Dir["article_search/*.rb"].each {|file| require_relative file }
require_relative 'TwitterWordSearch'


client = NYTMostPopularAPI.new
client.set_params("view", "all", "1")
# gets me today's keywords in all categories by most-viewed
keywords_NYT = client.get_response

num_keywords = 13
top_keywords = keywords_NYT[0..(num_keywords - 1)]

keywords_time_lapsed = {}
keywords_retweets = {}

# top_keywords.each do |keyword|
#   search = TwitterWordSearch.new
#   search_result = search.search_tweet(keyword)
#   keywords_time_lapsed[keyword] = search_result["time"]
#   keywords_retweets[keyword] = search_result["retweets"]
# end

# ap Hash[keywords_time_lapsed.sort_by{|k,v| v}]
# ap Hash[keywords_retweets.sort_by{|k,v| v}.reverse]

#pull top 5 key, plug them into the article searches
# use .keys on the resulting hash, like my_hash.keys[0..4]

keywords = ["Global Warming", "United States", "Republican Party", "Midterm Elections (2014)", "Boehner, John A"]

all_articles = {}

keywords.each do |keyphrase|
  all_articles[keyphrase] = []

  nyt = NYTArticleSearch.new
  time_spam_nyt = Date.today.prev_day.strftime.gsub(/-/, "")
  nyt.set_params(keyphrase, time_spam_nyt, "newest")
  all_articles[keyphrase] += nyt.get_response

  usa_today = USATodayArticleSearch.new
  usa_today.set_params(keyphrase)
  all_articles[keyphrase] += usa_today.get_response

  wapo = WaPoArticleSearch.new
  wapo.set_params(keyphrase)
  all_articles[keyphrase] += wapo.get_response

  guardian = GuardianArticleSearch.new
  guardian.set_params(keyphrase, "newest", "10")
  all_articles[keyphrase] += guardian.get_response
end

ap all_articles

#example output from USA today

# {
#     "Global Warming" => [
#         [0] #<Article:0x007fdc5ca29848 @title="Ex-JPMorgan lawyer tells tale of wrongdoing", @url="http://www.usatoday.com/story/money/business/2014/11/08/alayne-fleischmann-jpmorgan-whistleblower/18652819/", @abstract="Alayne Fleischmann alleges prosecutors didn't follow through on evidence she provided.", @source="www.usatoday.com", @image_url="USAIsLame", @published_at="Sat, 8 Nov 2014 07:02:03 GMT">,
#         [1] #<Article:0x007fdc5ca28b78 @title="Ebola survivors speak of suffering, service, faith", @url="http://www.usatoday.com/story/news/nation/2014/11/07/kent-brantly-to-speak-about-medicine-faith/18600745/", @abstract="Doctors Kent Brantly and Rick Sacra shared what got them through the worst of their fight.", @source="www.usatoday.com", @image_url="USAIsLame", @published_at="Fri, 7 Nov 2014 11:08:29 GMT">,
#         [2] #<Article:0x007fdc5ca23e70 @title="Police take down Dark Web markets around the globe", @url="http://www.usatoday.com/story/news/world/2014/11/07/police-knock-dark-web-markets-offline/18622501/", @abstract="The global law enforcement effort shut down more than 400 criminal websites on TOR.", @source="www.usatoday.com", @image_url="USAIsLame", @published_at="Fri, 7 Nov 2014 06:07:28 GMT">,

