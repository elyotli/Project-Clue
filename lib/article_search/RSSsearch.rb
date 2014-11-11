require 'rubygems'
require 'active_record'
require 'pg'
require_relative '../PopularitySearch'
require_relative '../../app/models/article'
require './Requests_and_Responses'

ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:database => 'Clue_development'
	)

module RSS_topic_search
	include Requests_and_Responses
	def search(topic)
		# puts "topic for this search is #{topic}"
		matches = []
		self.articles.each do |article|
			if article[:abstract] == nil
	      article[:abstract] = "a"
	    end

			if article[:title].downcase.include?(topic.downcase) || article[:abstract].downcase.include?(topic.downcase)
			 	matches << article
			 	# puts "found #{matches.length} matches for #{topic}"
			end
		end

		return matches
	end

	def convert(raw_articles)
		output = []
		raw_articles.each do |story|
			article = {}
			article[:title] = story[:title]
			article[:url] = story[:guid]
			article[:abstract] = story[:description]
			article[:published_at] = story[:pubDate]
			# popularity_client = PopularitySearch.new
		 #  popularity_client.set_params(article.url)
		  article[:twitter_pop] = get_twitter_popularity(article[:url]).to_i
		  #popularity_client.get_twitter_popularity
		 #  article.facebook_popularity = popularity_client.get_facebook_popularity
		 	output << article
		end
		return output
	end
end

