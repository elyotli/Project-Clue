namespace :day do
  desc "create a new day object"
  task make_new_day: :environment  do
    require "date"
    Day.create!(date: Date.today)
  end
end
