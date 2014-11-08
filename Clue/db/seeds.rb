# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ebola = Topic.create!(title: "ebola")
ferguson = Topic.create!(title: "ferguson")
election = Topic.create!(title: "election")
teletubbies = Topic.create!(title: "teletubbies")
obama = Topic.create!(title: "obama")

today = Day.create!(date: DateTime.now)

DayTopic.create!(topic_id: ebola.id, day_id: today.id )
DayTopic.create!(topic_id: ferguson.id, day_id: today.id )
DayTopic.create!(topic_id: election.id, day_id: today.id )
DayTopic.create!(topic_id: teletubbies.id, day_id: today.id )

Article.create!(title: "Ebola Volunteers Wrestle With Quarantine Mandates", url: "http://abcnews.go.com/Health/wireStory/ebola-volunteers-wrestle-quarantine-mandates-26776349")
Article.create!(url: "http://www.bbc.com/news/world-africa-29967124", title: "Ebola outbreak: Africa sets up $28.5m crisis fund")

Article.create!(title: "Man beaten at Ferguson protest strategy meeting", url: "http://www.stltoday.com/news/local/crime-and-courts/man-beaten-at-ferguson-protest-strategy-meeting/article_ba9ebc92-cb6f-57d9-bc00-1c99edc3c99c.html")
Article.create!(url: "http://www.11alive.com/story/news/local/2014/11/06/apd-ferguson-decision-preps/18624721/", title: "APD also preparing for Ferguson grand jury decision")

