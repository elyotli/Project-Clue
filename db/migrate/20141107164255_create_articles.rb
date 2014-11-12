class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    	t.string :title
  		t.text :abstract, :default => "No abstract provided."
  		t.string :url
  		t.string :source, :default => "No source provided."
  		t.string :image_url, :default => "http://www.standard.co.uk/incoming/article9168889.ece/alternates/w620/KETCHUP0503A.jpg"

  		t.date :published_at, :default => Date.today

  		t.integer :twitter_popularity, :default => 1
  		t.integer :facebook_popularity, :default => 1
  		t.integer :google_trend_index, :default => 1

      t.timestamps
    end
  end
end
