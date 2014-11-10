namespace :day do
  Rails.env = 'development'
  desc "create a new day object"
  task make_new_day: :environment  do
    # require "Date"
    Day.create!(date: Date.today)
  end
end