require 'rubygems'
require 'active_record'
require 'pg'
require_relative '../PopularitySearch'
require_relative '../../app/models/article'
require './Requests_and_Responses'

# require '../../Requests_and_Responses'



ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:database => 'Clue_development'
	)

module RSS_topic_search
	include Requests_and_Responses
	def search(topic)
		matches = []
		self.articles.each do |article|
			if article[:abstract] == nil
	      		article[:abstract] = "a"
	    	end

			if article[:title].downcase.include?(topic.downcase) || article[:abstract].downcase.include?(topic.downcase)
			 	matches << article			 	
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
			article[:image_url] = story[@image]
			if article[:image_url] == nil
				article[:image_url] = "http://shackmanlab.org/wp-content/uploads/2013/07/person-placeholder.jpg"
			end

		  article[:twitter_pop] = get_twitter_popularity(article[:url]).to_i/@followers
		  article[:facebook_popularity] = get_facebook_popularity(article[:url]).to_i

		 	output << article
		end
		return output
	end
end

