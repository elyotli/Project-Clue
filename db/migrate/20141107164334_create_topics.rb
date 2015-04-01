class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
  		t.string 	:title
  		t.string 	:image_url
  		t.integer 	:twitter_popularity, :default => 1
      	t.integer 	:facebook_popularity, :default => 1
      	t.integer 	:google_trend_index, :default => 1

      	t.timestamps
    end
  end
end
