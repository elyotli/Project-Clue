namespace :day do

  desc "create a new day object"
  task :make_new_day => :environment  do
    # require "Date"
    # if Rails.env == "development"
      Day.create(date: Date.today)
    # end
  end
end