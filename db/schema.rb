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

ActiveRecord::Schema.define(version: 20141113154308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_topics", force: true do |t|
    t.integer  "topic_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: true do |t|
    t.text     "title"
    t.text     "abstract",            default: "No abstract provided."
    t.text     "url"
    t.text     "source",              default: "No source provided."
    t.text     "image_url",           default: "http://dribbble.s3.amazonaws.com/users/107262/screenshots/462548/ketchup_logo_1.jpg"
    t.date     "published_at",        default: '2014-11-14'
    t.integer  "twitter_popularity",  default: 1
    t.integer  "facebook_popularity", default: 1
    t.integer  "google_trend_index",  default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_topics", force: true do |t|
    t.integer  "topic_id"
    t.integer  "day_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "popularities", force: true do |t|
    t.integer  "topic_id"
    t.integer  "day_id"
    t.integer  "twitter_popularity",  default: 1
    t.integer  "facebook_popularity", default: 1
    t.integer  "google_trend_index",  default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.string   "image_url",  default: "http://dribbble.s3.amazonaws.com/users/107262/screenshots/462548/ketchup_logo_1.jpg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
