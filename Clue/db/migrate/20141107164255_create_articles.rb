class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    	t.string :title
  		t.string :abstract
  		t.string :url
  		t.string :source
  		t.string :image_url

  		t.date :published_at

  		t.integer :twitter_popularity
  		t.integer :facebook_popularity
  		t.integer :google_trend_index

      t.timestamps
    end
  end
end
