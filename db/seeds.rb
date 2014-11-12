require 'date'

topics = [
	{ title: "Ebola",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Ebola Volunteers Wrestle With Quarantine Mandates",
				url: "http://abcnews.go.com/Health/wireStory/ebola-volunteers-wrestle-quarantine-mandates-26776349",
				image_url: 'http://a.abcnews.com/images/Health/WireAP_5a58f1bc3fc44c0697dddb061e48c419_16x9_992.jpg',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			},
			{ title: "Ebola outbreak: Africa sets up $28.5m crisis fund",
				url: "http://www.bbc.com/news/world-africa-29967124",
				image_url: 'http://news.bbcimg.co.uk/media/images/78850000/jpg/_78850747_78850746.jpg',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			}
		]
	},
	{ title: "Ferguson",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Man beaten at Ferguson protest strategy meeting",
				url: "http://www.gannett-cdn.com/-mm-/19d0fcd52f809fa70639c9d712cf8fe71f52b1a4/c=403-0-2797-1800&r=x404&c=534x401/local/-/media/WXIA/WXIA/2014/11/06/635509112402151091-121221113044-occupy-20arrest-1-.jpg",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			},
			{ title: "APD also preparing for Ferguson grand jury decision",
				url: "http://www.gannett-cdn.com/-mm-/19d0fcd52f809fa70639c9d712cf8fe71f52b1a4/c=403-0-2797-1800&r=x404&c=534x401/local/-/media/WXIA/WXIA/2014/11/06/635509112402151091-121221113044-occupy-20arrest-1-.jpg",
				image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			}
		]
	},
	{ title: "Election",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Big Review Set by Democrats After Election Losses",
				url: "http://abcnews.go.com/Politics/wireStory/big-review-set-democrats-election-losses-26779779",
				image_url: 'http://a.abcnews.com/images/Politics/WireAP_f64c7a48192846d9bac962864421b61b_16x9_992.jpg',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			},
			{ title: "Examining The Polls and The Election Results",
				url: "http://www.realclearpolitics.com/articles/2014/11/07/examining_the_polls_and_the_election_results_.html",
				image_url: 'http://images.rcp.realclearpolitics.com/257889_5_.jpg',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			}
		]
	},
	{ title: "Teletubbies",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "Teletubby' arrested for stealing Chinese food and stashing it in 'man purse",
				url: "http://www.mirror.co.uk/incoming/teletubby-arrested-stealing-chinese-food-4557253",
				image_url: 'http://i.perezhilton.com/wp-content/uploads/2014/11/a-man-wearing-a-teletubby-costume-broke-into-a-home-in-pennsylvania.gif',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			},
			{ title: "A Man Wearing A Teletubby Costume Broke Into A Home In Pennsylvania!",
				url: "http://perezhilton.com/2014-11-02-man-wearing-teletubby-costume-breaks-into-persons-home#.VF7Bj_TF_Fc",
				image_url: 'http://i.perezhilton.com/wp-content/uploads/2014/11/a-man-wearing-a-teletubby-costume-broke-into-a-home-in-pennsylvania.gif',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			}
		]
	},
	{ title: "Obama",
		image_url: 'https://assets.digitalocean.com/articles/Unicorn_Ruby/img1.png',
		articles: [
			{ title: "'We Got Beat': Obama Takes Responsibility for Midterm Results",
				url: "http://www.nbcnews.com/politics/barack-obama/we-got-beat-obama-takes-responsibility-midterm-results-n244616",
				image_url: 'http://static01.nyt.com/images/2012/11/07/timestopics/Barack-Obama/Barack-Obama-sfSpan.jpg',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			},
			{ title: "Obama: 'I’m going to do what I need to do' on immigration",
				url: "http://www.foxnews.com/politics/2014/11/09/obama-ill-do-what-need-to-do-on-immigration/",
				image_url: 'http://static01.nyt.com/images/2012/11/07/timestopics/Barack-Obama/Barack-Obama-sfSpan.jpg',
				abstract: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sollicitudin mi eu venenatis rhoncus. Sed eget mi at tellus cursus mattis. Nullam convallis ultrices mi, interdum auctor orci elementum sodales. Mauris eget ullamcorper nisl.',
				source: 'New York Times'
			}
		]
	}
]

days = (1..31).to_a.map do |day|
	Date.new(2014, 10, day).to_s
end

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
					abstract: article[:abstract],
					source: article[:source],
					twitter_popularity: randomPopularity
				)
				ArticleTopic.create!(topic_id: topicObj.id , article_id: articleObj.id)
				counter += 1
			end
		end
	end
end

Day.all.each do |day|
	day.topics.each do |topic|
		topics_hash = topics.select do |t|
			if(topic.title.match (/#{t[:title]}/))
				true
			else
				false
			end
		end[0]
		('2014-10-01'..day.date.to_s).to_a.each.with_index do |date,index|
			if(date != day.date.to_s)
				counter = 0
				3.times do
					topics_hash[:articles].each do |article|
						articleObj = Article.create!(
							title: "#{date} #{topic.title} #{counter} #{article[:title]}",
							url: article[:url],
							published_at: date,
							image_url: article[:image_url],
							abstract: article[:abstract],
							source: article[:source],
							twitter_popularity: randomPopularity
						)
						ArticleTopic.create!(topic_id: topic.id , article_id: articleObj.id)
						counter += 1
					end
				end
			end
		end
	end
end

Topic.all.each do |topic|
	Day.all.each do |day|
		Popularity.create!(
			topic_id: topic.id,
			day_id: day.id,
			google_trend_index: randomPopularity
		)
	end
end
