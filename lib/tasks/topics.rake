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
require_relative "../BingImageSearch"
require_relative "../NewYorkTimes"
require "./Requests_and_Responses"
require "awesome_print"
# require "Date"

namespace :topic do
  desc "get topics"
  task get_topics: :environment do
    include Requests_and_Responses
    # client = NYTMostPopularAPI.new
    # search = TwitterWordSearch.new
    nyt = NewYorkTimes.new
    nyt.get_initial_articles

    todays_articles = {}
    articles_to_save = {}
    final_topics = []

    news_APIs = [NewYorkTimesSearch.new,
                 Guardian.new]
                 # ,
                 # WashPost.new]
    news_RSS = [AbcNewsArticleSearch.new,
                BbcNewsArticleSearch.new,
                CbsNewsArticleSearch.new,
                CNNArticleSearch.new,
                FoxNewsArticleSearch.new,
                NbcNewsArticleSearch.new,
                NprArticleSearch.new,
                ReutersArticleSearch.new]

    # idea here is to check other news sources if they are cover the same topics as NYT

    champions = nyt.all_articles.take(10)
    champion_topics = champions.map do |article|
      article[:keywords]
    end

    puts "got champions:"
    # ap champion_topics

    ranked_keywords_with_count = []
    champion_topics.each do |topic_set|
      ranked_keywords_with_count << rank_keywords(clean_up_text_array(topic_set), news_APIs, news_RSS)
    end

    ap ranked_keywords_with_count

    # if we have more time, i would like to do a test on how common the keyword is to filter on some garbarge
    # for now, i'm giving single word a penalty on the article count
    single_word_penalty = 0.7

    # this is an array (n=10) of list of topic:article_count
    final_keywords = ranked_keywords_with_count.map do |keywords_sets|
      select_phrase(keywords_sets, single_word_penalty)
    end

    final_keywords = final_keywords.sort_by{|hash| hash.values[0]}.reverse
    final_keywords = final_keywords.uniq
    final_keywords[0..3].each do |keyword_hash|
      keyword = keyword_hash.keys[0]
      today = Day.find_or_create_by(date: Date.today)

      #find the images and save them
      bing_client = BingImageSearch.new(keyword)
      image_url = bing_client.get_image_url
      topic = Topic.find_or_create_by(title: keyword)
      daytopic = DayTopic.find_or_create_by(topic_id: topic.id, day_id: today.id)
      p "Topic: #{topic}"
    end
  end
end

def rank_keywords(word_array, news_APIs=[], news_RSS=[])
  todays_articles={}

  word_array.each do |topic|
    todays_articles[topic] = []
    todays_articles[topic] += news_APIs.map do |source|
      p "searching for #{topic} in #{source.class}"
      source.search(topic)
    end
    todays_articles[topic] += news_RSS.map do |source|
      p "searching for #{topic} in #{source.class}"
      source.search(topic)
    end
    todays_articles[topic].flatten!
  end
  #get the count of articles for each word
  topic_article_count = Hash[todays_articles.map{|k, v| [k, v.length]}]
  #sort the words by the count
  #hash format, key is keyword, value is count
  topic_article_count = Hash[topic_article_count.sort_by{|k, v| v}.reverse]
  return topic_article_count
end

def clean_up_text_array(word_array)
  word_array.map do |word|
    word = word.gsub(/\(.+\)/, "")
    word.strip
  end
end

def select_phrase(selection, single_word_penalty)
  #this is an array of hashes of keyword:count
  refined_index = selection.map do |k,v|
    if k == "BARACK OBAMA" #the presidential penalty
      (v * 0.6).floor
    elsif k.split(" ").length > 1
      #if this is a multi word phrase
      v
    else
      (v * single_word_penalty).floor
    end
  end
  max_index = refined_index.each_with_index.max[1]
  return_hash = {
    selection.keys[max_index] => refined_index[max_index]
  }
  return return_hash
end

  # test data:
  # initial_topics = []
  # initial_topics[0] = ["Net Neutrality",
  #         "Obama, Barack",
  #         "Federal Communications Commission",
  #         "Wheeler, Thomas E"]
  # initial_topics[1] = ["Potatoes",
  #         "Genetic Engineering",
  #         "Agriculture and Farming",
  #         "Simplot, J R, Co",
  #         "Biotechnology and Bioengineering",
  #         "French Fries"]
  # initial_topics[2] = ["Search and Seizure",
  #         "Crime and Criminals",
  #         "Police",
  #         "civil asset forfeiture",
  #         "Justice Department"]
  # initial_topics[3] = ["Alternative and Renewable Energy",
  #         "Denmark",
  #         "Electric Light and Power",
  #         "Greenhouse Gas Emissions"]
  # initial_topics[4] = ["Mormons ",
  #         "Smith, Joseph ",
  #         "Polygamy"]
  # initial_topics[5] = ["Ebola Virus",
  #         "Series",
  #         "Emerging Infectious Diseases ",
  #         "Liberia",
  #         "Epidemics",
  #         "Children and Childhood",
  #         "Research",
  #         "International Medical Corps",
  #         "The Ebola Ward",
  #         "Ebola Ward, The"]
  # initial_topics[6] = ["Education ",
  #         "Tests and Examinations",
  #         "Florida",
  #         "Teachers and School Employees",
  #         "Duncan, Arne",
  #         "Education Department ",
  #         "Common Core",
  #         "Palm Beach "]

 # {"POTATOES" => 23,
 #  "GENETIC ENGINEERING" => 20,
 #  "SIMPLOT, J R, CO" => 10}
