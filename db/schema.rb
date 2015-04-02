# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150401035650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.integer  "topic_id"
    t.text     "name"
    t.text     "abstract",            default: "No abstract provided."
    t.text     "url"
    t.text     "source",              default: "No source provided."
    t.text     "image_url"
    t.date     "published_at",        default: '2015-04-01'
    t.integer  "twitter_popularity",  default: 1
    t.integer  "facebook_popularity", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "name"
    t.string   "image_url"
    t.integer  "twitter_popularity",  default: 1
    t.integer  "facebook_popularity", default: 1
    t.integer  "google_trend_index",  default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits", force: true do |t|
    t.integer "topic_id"
  end

end
