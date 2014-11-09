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

yesterday = Day.create!(date: Date.yesterday)
today = Day.create!(date: Date.today)


DayTopic.create!(topic_id: ebola.id, day_id: today.id )
DayTopic.create!(topic_id: ferguson.id, day_id: today.id )
DayTopic.create!(topic_id: election.id, day_id: today.id )
DayTopic.create!(topic_id: teletubbies.id, day_id: today.id )

ebo1 =Article.create!(title: "Ebola Volunteers Wrestle With Quarantine Mandates", url: "http://abcnews.go.com/Health/wireStory/ebola-volunteers-wrestle-quarantine-mandates-26776349")
ebo2 = Article.create!(url: "http://www.bbc.com/news/world-africa-29967124", title: "Ebola outbreak: Africa sets up $28.5m crisis fund")

ferg1 = Article.create!(title: "Man beaten at Ferguson protest strategy meeting", url: "http://www.stltoday.com/news/local/crime-and-courts/man-beaten-at-ferguson-protest-strategy-meeting/article_ba9ebc92-cb6f-57d9-bc00-1c99edc3c99c.html")
ferg2 = Article.create!(url: "http://www.11alive.com/story/news/local/2014/11/06/apd-ferguson-decision-preps/18624721/", title: "APD also preparing for Ferguson grand jury decision")

elec1 = Article.create!(title: "Big Review Set by Democrats After Election Losses", url:"http://abcnews.go.com/Politics/wireStory/big-review-set-democrats-election-losses-26779779")
elec2 = Article.create!(title: "Examining The Polls and The Election Results", url: "http://www.realclearpolitics.com/articles/2014/11/07/examining_the_polls_and_the_election_results_.html")

tele1 = Article.create!(title: "Teletubby' arrested for stealing Chinese food and stashing it in 'man purse", url:"http://www.mirror.co.uk/incoming/teletubby-arrested-stealing-chinese-food-4557253")
tele2 = Article.create!(title: "A Man Wearing A Teletubby Costume Broke Into A Home In Pennsylvania!", url: "http://perezhilton.com/2014-11-02-man-wearing-teletubby-costume-breaks-into-persons-home#.VF7Bj_TF_Fc")

ArticleTopic.create!(topic_id: ebola.id , article_id: ebo1.id )
ArticleTopic.create!(topic_id: ebola.id , article_id: ebo2.id )
ArticleTopic.create!(topic_id: ferguson.id , article_id: ferg2.id )
ArticleTopic.create!(topic_id: ferguson.id , article_id: ferg2.id )
ArticleTopic.create!(topic_id: election.id , article_id: elec1.id )
ArticleTopic.create!(topic_id: election.id , article_id: elec2.id )
ArticleTopic.create!(topic_id: teletubbies.id , article_id: tele1.id )
ArticleTopic.create!(topic_id: teletubbies.id , article_id: tele2.id )

