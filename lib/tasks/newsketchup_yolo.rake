desc "Get everything, because YOLO!"
namespace :newsketchup do
  task :yolo => ["topic:get_topics", "topics:trends", "get_topics"]
end