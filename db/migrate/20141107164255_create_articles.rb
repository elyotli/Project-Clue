


class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    	t.text :title
  		t.text :abstract, :default => "No abstract provided."
  		t.text :url
  		t.text :source, :default => "No source provided."
  		t.text :image_url #, :default => "http://dribbble.s3.amazonaws.com/users/107262/screenshots/462548/ketchup_logo_1.jpg"

  		t.date :published_at, :default => Date.today

  		t.integer :twitter_popularity, :default => 1
  		t.integer :facebook_popularity, :default => 1
  		t.integer :google_trend_index, :default => 1

      t.timestamps
    end
  end
end
