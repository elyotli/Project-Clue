class CreatePopularities < ActiveRecord::Migration
  def change
    create_table :popularities do |t|
  		t.integer :topic_id
  		t.integer :day_id
  		t.integer :twitter_popularity, :default => 1
      t.integer :facebook_popularity, :default => 1
      t.integer :google_trend_index, :default => 1

      t.timestamps
    end
  end
end
