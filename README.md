News Ketchup
============

<b>News Ketchup</b>'s purpose is to help users of the app rid themselves of moments of being left out of a conversation due to ignorance of today's trending news topics.

=== Screenshots
![NewsKetchup_Landing_Page](https://lh4.googleusercontent.com/aWufdFJQ-wOIGpZ7NQYYuik4pL_RFp2t9qmLOpgJABZLIdD7fJ2BQbClR8au-SftAwHkXyWKuyM=w1416-h685)

=== System Requirements
- Ruby 2.0.0
- Rails 4.1.6
- Postgres 9.3.5
- Internet access

=== External APIs & Libraries
APIs from:
	New York Times
	USA Today
	Washington Post
	Guardian New

RSS Feeds from:



# User Stories

* I want to be able to see the top 5 trending topics for today
	* I would like to be able to see quick info about each trending topic
		* picture
		* topics
		* stats
		* most recent articles with heading, lead, quick stat, source
	* I would like to be able to see previous days top topics
	* I want to be able to interact with a timeline that will give statistics and news articles over time on a selected topic
		* I want the entire timeline to be visible with aggregated statistics
			* number of tweets or retweets
			* number of articles on major news sources
			* ...
		* I want to be able to see specific stats for each day on the graph when I hover over it
		* I want to be able to see relevant news articles for a specific day when I click on the graph
			* picture
			* topics and lead
			* quick stat
			* source
			* link to full article
		* I would like to be able to cycle through relevant news articles for each day
		(*) I would like to be able to upvote or downvote an article depending on relevance
		(*) forward tracking of topics
		(*) default articles when a topic is first chosen should be over the entire timeline

![whiteboard_backlog](project management/whiteboard_backlog.jpg)

![whiteboard_algorithm](project management/whiteboard_algorithm.jpg)

![wireframe](project management/wireframe.jpg)

![db_schema_final](project management/db_schema_final.png)
