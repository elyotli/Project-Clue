class CreatePopularities < ActiveRecord::Migration
  def change
    create_table :popularities do |t|
  		t.integer :topic_id
  		t.integer :day_id
  		t.integer :twitter_popularity
  		t.integer :facebook_popularity
  		t.integer :google_trend_index

      t.timestamps
    end
  end
end
