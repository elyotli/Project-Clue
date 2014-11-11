require_relative "../TwitterWordSearch"
require_relative "../APIControl"
require_relative "../article_search/NYTMostPopularAPI"
require_relative "../article_search/NYTArticleSearch"
require_relative "../article_search/GuardianArticleSearch"
require_relative "../article_search/USATodayArticleSearch"
require_relative "../article_search/WaPoArticleSearch"
require_relative "../article_search/RSSGrabber"
require_relative "../article_search/CNNArticleSearch"
require_relative "../article_search/AbcNewsArticleSearch"
require_relative "../article_search/CbsNewsArticleSearch"
require_relative "../article_search/FoxNewsArticleSearch"
require_relative "../article_search/ReutersArticleSearch"
require_relative "../article_search/NbcNewsArticleSearch"
require_relative "../article_search/NprArticleSearch"
require_relative "../article_search/BbcNewsArticleSearch"



#get articles
#twitter word search to rank those keywords
#rss search on top keyword, try not to get 5 articles
#run again if we don't 


namespace :articles do
  desc "get new articles and topics"
  task update_articles: :environment do
    # require "Date"
    require "awesome_print"

    client = NYTMostPopularAPI.new
    search = TwitterWordSearch.new

    client.set_params("view", "serious", "1")
    nyt1 = client.get_response
    client.set_params("view", "serious", "1", "20")
    nyt2 = client.get_response
    client.set_params("view", "serious", "1", "40")
    nyt3 = client.get_response
    client.set_params("view", "serious", "1", "60")
    nyt4 = client.get_response
    client.set_params("view", "serious", "1", "80")
    nyt5 = client.get_response

    nyt_top_articles = nyt1 += nyt2 += nyt3 += nyt4 += nyt5


    nyt_top_articles.each do |contender|      
      popularity_client = PopularitySearch.new
      popularity_client.set_params(contender[:url]) 
      contender[:tweets] = popularity_client.get_twitter_popularity
      contender[:shares] = popularity_client.get_facebook_popularity
      contender[:socialpop] = contender[:tweets] + contender [:shares]
    end


    #     #&:tweets
    #   #tried to combine these two conditions with an || but got errors
     nyt_top_articles.delete_if do |article| 
       article[:url].include? "blogs.nytimes"
     end 

     nyt_top_articles.delete_if do |article| 
       article[:key_words].length < 1
     end 

     nyt_top_articles.sort! {|a,b| b[:socialpop] <=> a[:socialpop]}
     champions = nyt_top_articles.take(20)
     puts "got champions"
   # ###############################################

   # #champions is an array that has five objects in it
   #  p champions.class
   #  p champions.length
   #  ap champio


    # num_keywords = 10
    # top_keywords = keywords_NYT[0..(num_keywords - 1)]

    # keywords_time_lapsed = {}
    # # keywords_retweets = {}

    # # puts "keywords before twitter filtering"
    # # ap top_keywords

    # top_keywords.each do |keyword|
    #   search_result = search.search_tweet(keyword)
    #   keywords_time_lapsed[keyword] = search_result["time"]
    #   keywords_retweets[keyword] = search_result["retweets"]
    # end

    # # # pull top 5 key, plug them into the article searches
    # # # use .keys on the resulting hash, like my_hash.keys[0..4]

    # Hash[keywords_retweets.sort_by{|k, v| v}.reverse]
    # top_five_keywords = keywords_retweets.keys[0..4]

    # # # top_five_keywords = top_keywords.slice(0,4)

    #######################################


    # puts "top 5 keywords"
     # top_five_keywords = ["Obama", "Republican", "Ebola", "republican", "kim kardashian", "School" ]
    # #find articles from all news sources based on each of the top five keywords:

    # all_articles = {}
    # nyt_articles = nil
    # wapo_articles = nil
    # guardian_articles = nil
    # top_five_keywords.each do |keyphrase|
    #   all_articles[keyphrase] = []

    #   puts "finding articles for #{keyphrase} in NYT"
    #   nyt = NYTArticleSearch.new
    #   time_spam_nyt = Date.today.prev_day.strftime.gsub(/-/, "")
    #   nyt.set_params(keyphrase, time_spam_nyt, "newest")
    #   nyt_articles = nyt.get_response
    #   # all_articles[keyphrase] += nyt.get_response

    #   # # puts "finding articles for #{keyphrase} in usa today"
    #   # # usa_today = USATodayArticleSearch.new
    #   # # usa_today.set_params(keyphrase)
    #   # # all_articles[keyphrase] += usa_today.get_response

    #   # puts "finding articles for #{keyphrase} in wapo"
    #   # wapo = WaPoArticleSearch.new
    #   # wapo.set_params(keyphrase)
    #   # wapo_articles = wapo.get_response
    #   # all_articles[keyphrase] += wapo.get_response

    # puts "finding articles for #{keyphrase} in guardian"
    # guardian = GuardianArticleSearch.new
    # guardian.set_params(keyphrase, "newest", "10")
    # guardian_articles = guardian.get_response
    #   # all_articles[keyphrase] += guardian.get_response
    # end
    # api_articles = []
    # api_articles += nyt_articles
    # # api_articles += wapo_articles
    # api_articles += guardian_articles

    cnn = CNNArticleSearch.new
    nbc = NbcNewsArticleSearch.new
    bbc = BbcNewsArticleSearch.new
    cbs = CbsNewsArticleSearch.new
    reu = ReutersArticleSearch.new
    npr = NprArticleSearch.new
    fox = FoxNewsArticleSearch.new
    abc = AbcNewsArticleSearch.new

    puts "initalized all rss feeds"
    shown_articles = {}
    champions.each do |article|
     matches = []
     matches << cnn.find_articles_by_topic(article.keyword[0])
     matches << nbc.find_articles_by_topic(article.keyword[0])
     matches << abc.find_articles_by_topic(article.keyword[0])
     matches << fox.find_articles_by_topic(article.keyword[0])
     matches << reu.find_articles_by_topic(article.keyword[0])
     matches << npr.find_articles_by_topic(article.keyword[0])
     matches << cbs.find_articles_by_topic(article.keyword[0])
     if matches.legnth > 5
        matches.sort! {|a, b| b.twitter_popularity <=> a.twitter_popularity}
        shown_articles[article.keyword[0]] = matches.take(5)      
     end
     break if shown_articles.length > 4
    end

    ap shown_articles
      

      #if the story has the keyword in it, a


    # top_five_keywords = ["Mormons", "Police", "Education"]

    # rss_articles.each do |article|
    #   top_five_keywords.each do |keyphrase|
    #     ap article
    #     if article.abstract == nil
    #       article.abstract = " "
    #     end
    #     all_articles[keyphrase] << article if article.title.downcase.include?(keyphrase.downcase) || article.abstract.downcase.include?(keyphrase.downcase)
    #   end
    # end


    # # puts all_articles.length
    # #all_articles will have a large number of articles, this is where we want to filter down to a set number of articles per keyword

    # #We then create a new Article object for each of the articles.

    # shown_articles = []
    # top_five_keywords.each do |keyword|
    #   all_articles[keyword].sort! {|a,b| b.twitter_popularity <=> a.twitter_popularity }
    #   shown_articles << all_articles[keyword].slice(0, 5)
    # end

    # ap shown_articles.each
  end
end
