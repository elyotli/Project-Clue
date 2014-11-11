require 'active_record'
require 'pg'
require_relative '../app/models/topic.rb'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database =>  'Clue_development'
)

p Topic.new()