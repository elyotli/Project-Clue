# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


every 1.day, at: '6:00 am' do
  rake "articles:update_articles"
end

every 1.day, at: '12:01 am' do
  rake "day:make_new_day"
end

# every 1.day, :at => '5:10 pm' do
#   command "touch ~/Desktop/Project-Clue/Clue/whenever_test.txt"
# end
