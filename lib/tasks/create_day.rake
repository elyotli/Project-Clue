namespace :db do
  desc "get new articles and topics"
  task :create_a_day => :environment do
    puts Rails.env
      Day.create!(date: Date.today)
  end
end