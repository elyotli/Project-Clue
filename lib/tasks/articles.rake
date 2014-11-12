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
require_relative "../NewYorkTimes"


namespace :articles do
  desc "get new articles and topics"
  task update_articles: :environment do
    # require "Date"
    require "awesome_print"

    # client = NYTMostPopularAPI.new
    # search = TwitterWordSearch.new
    nyt = NewYorkTimes.new
    nyt.get_initial_articles


    champions = nyt.all_articles.take(20)
    puts "got champions"

    # binding.pry
  news_APIs = [NewYorkTimesSearch.new,
               Guardian.new,
               WashPost.new]

  news_RSS = [AbcNewsArticleSearch.new,
              BbcNewsArticleSearch.new,
              CbsNewsArticleSearch.new,
              CNNArticleSearch.new,
              FoxNewsArticleSearch.new,
              NbcNewsArticleSearch.new,
              NprArticleSearch.new,
              ReutersArticleSearch.new]

  todays_articles = {}
  articles_to_save = {}

  final_topics = []


    topics = []
    champions.slice!(0..4).each do |champion|
      topics << champion[:keywords][0]
    end

    topics.each do |topic|
      todays_articles[topic] = []
      todays_articles[topic] = news_APIs.map do |source|
        p "searching for #{topic} in #{source.class}"
        source.search(topic)
      end.flatten
      todays_articles[topic] += news_RSS.map do |source|

        source.search(topic)
      end

      todays_articles[topic].flatten!


      todays_articles[topic] = todays_articles[topic].sort_by{ |article| article[:twitter_pop] }.reverse
      articles_to_save[topic] = todays_articles[topic][0..3]
      if articles_to_save[topic].length == 4
        final_topics << articles_to_save[topic]
        if final_topics == 4
          break

      end
    end

end
  ap final_topics

    # puts "top 5 keywords"
     # top_five_keywords = ["Obama", "Republican", "Ebola", "republican", "kim kardashian", "School" ]



  end
end
