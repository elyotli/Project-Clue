topic_1 = Topic.create!(name: 'topic 1')

Article.create!(topic: topic_1, name: 'article 1')