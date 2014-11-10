topics = [
	{ title: "Ebola",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Ebola Volunteers Wrestle With Quarantine Mandates",
				url: "http://abcnews.go.com/Health/wireStory/ebola-volunteers-wrestle-quarantine-mandates-26776349",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			},
			{ title: "Ebola outbreak: Africa sets up $28.5m crisis fund",
				url: "http://www.bbc.com/news/world-africa-29967124",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			}
		]
	},
	{ title: "Ferguson",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Man beaten at Ferguson protest strategy meeting",
				url: "http://www.stltoday.com/news/local/crime-and-courts/man-beaten-at-ferguson-protest-strategy-meeting/article_ba9ebc92-cb6f-57d9-bc00-1c99edc3c99c.html",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			},
			{ title: "APD also preparing for Ferguson grand jury decision",
				url: "http://www.11alive.com/story/news/local/2014/11/06/apd-ferguson-decision-preps/18624721/",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			}
		]
	},
	{ title: "Election",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Big Review Set by Democrats After Election Losses",
				url: "http://abcnews.go.com/Politics/wireStory/big-review-set-democrats-election-losses-26779779",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			},
			{ title: "Examining The Polls and The Election Results",
				url: "http://www.realclearpolitics.com/articles/2014/11/07/examining_the_polls_and_the_election_results_.html",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			}
		]
	},
	{ title: "Teletubbies",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Teletubby' arrested for stealing Chinese food and stashing it in 'man purse",
				url: "http://www.mirror.co.uk/incoming/teletubby-arrested-stealing-chinese-food-4557253",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			},
			{ title: "A Man Wearing A Teletubby Costume Broke Into A Home In Pennsylvania!",
				url: "http://perezhilton.com/2014-11-02-man-wearing-teletubby-costume-breaks-into-persons-home#.VF7Bj_TF_Fc",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			}
		]
	},
	{ title: "Obama",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "'We Got Beat': Obama Takes Responsibility for Midterm Results",
				url: "http://www.nbcnews.com/politics/barack-obama/we-got-beat-obama-takes-responsibility-midterm-results-n244616",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			},
			{ title: "Obama: 'I’m going to do what I need to do' on immigration",
				url: "http://www.foxnews.com/politics/2014/11/09/obama-ill-do-what-need-to-do-on-immigration/",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png'
			}
		]
	}
]

days = [Date.yesterday.yesterday, Date.yesterday, Date.today]

def randomPopularity()
	(rand*1000).round
end

days.each do |day|
	dayObj = Day.create!(date: day)

	topics.each do |topic|
		topicObj = Topic.create!(title: "#{day} #{topic[:title]}", image_url: topic[:image_url])
		DayTopic.create!(topic_id: topicObj.id, day_id: dayObj.id)

		counter = 0
		3.times do
			topic[:articles].each do |article|
				articleObj = Article.create!(
					title: "#{day} #{topic[:title]} #{counter} #{article[:title]}",
					url: article[:url],
					published_at: day,
					image_url: article[:image_url],
					twitter_popularity: randomPopularity,
	        facebook_popularity: randomPopularity,
	        google_trend_index: randomPopularity
				)
				ArticleTopic.create!(topic_id: topicObj.id , article_id: articleObj.id)
				counter += 1
			end
		end

		30.times do
			Popularity.create!(
				topic_id: topicObj.id,
				day_id: dayObj.id,
				twitter_popularity: randomPopularity,
				facebook_popularity: randomPopularity,
				google_trend_index: randomPopularity
			)
		end
	end
end
