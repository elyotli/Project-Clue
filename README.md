News Ketchup
============

**News Ketchup's** purpose is to help users of the app rid themselves of moments of being left out of a conversation due to ignorance of today's trending news topics.
============

# How It Works:
1. First, News Ketchup pulls the latest headline news articles from multiple reputable news sources.
2. To determine how popular (trending) each article is, we cross-check the article's keywords on twitter and facebook and calculating popularity by number of favorites, tweets, retweets, shares, and likes.
3. The four most popular topics are saved to the database and images for these topics are displayed on the landing page.
4. We then pull all articles from all news sources based on these four trending topics, sort them again by popularity, and display the four most popular articles per keyword on the main page.
5. We also utilize Google Trends API to populate our graph representing popularity of each topic over time.
============


# Screenshots:
![NewsKetchup_Landing_Page](https://raw.githubusercontent.com/drennen42/drennen42.github.io/master/images/NewsKetchup_Landing.png)

![NewsKetchup_main_old](https://raw.githubusercontent.com/drennen42/drennen42.github.io/master/images/NewsKetchup_Main_Old.png)
============

# System Requirements
- Ruby 2.0.0
- Rails 4.1.6
- Postgres 9.3.5
- Internet access
============

# External APIs & Libraries Utilized:
#### APIs:
-	[New York Times](http://api.nytimes.com/svc/search/v2/)
-	[USA Today](http://api.usatoday.com/)
-	[Washington Post](http://api.washingtonpost.com/trove/v1/)
-	[Guardian News](http://content.guardianapis.com/)
- [Google Trends](www.google.com/trends)

#### RSS Feeds:
- [ABC News](http://feeds.abcnews.com/abcnews/topstories)
- [BBC News](http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml)
- [CBS News](http://www.cbsnews.com/latest/rss/main)
- [CNN News](http://rss.cnn.com/rss/cnn_topstories.rss)
- [Fox News](http://feeds.foxnews.com/foxnews/most-popular)
- [NBC News](http://feeds.nbcnews.com/feeds/topstories)
- [NPR News](http://www.npr.org/rss/rss.php)
- [Reuters News](http://feeds.reuters.com/reuters/topNews)

#### Social Media Feeds:
- [Twitter API](https://dev.twitter.com)
- [Facebook](http://graph.facebook.com)
============

# Getting Started

1. Clone this repo to your local machine: <tt>git clone https://github.com/elyotli/Project-Clue.git</tt>
2. Install dependencies: <tt>bundle install</tt>
3. Initialize database: <tt>rake db:reset</tt>
4. Start rails server: <tt>rails s</tt>
5. Get today's topics and articles: <tt>rake newsketchup:yolo</tt>
6. Visit http://localhost:3000
============

# Schema:
![Schema](project management/db_schema_final.png)
============
<!-- # User Stories

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
		(*) default articles when a topic is first chosen should be over the entire timeline -->

### Extra Images:
![whiteboard_backlog](project management/whiteboard_backlog.jpg)

![whiteboard_algorithm](project management/whiteboard_algorithm.jpg)

![wireframe](project management/wireframe.jpg)
