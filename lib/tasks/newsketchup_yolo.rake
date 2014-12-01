desc "Get everything, because YOLO!"
namespace :newsketchup do
  task :yolo => ["topics:get_topics", "topics:get_trends", "topics:get_articles"]
end