namespace :day do
  desc "create a new day object"
  task create_day: :environment do
    require "Date"
    Day.create!(date: Date.today)
  end
end