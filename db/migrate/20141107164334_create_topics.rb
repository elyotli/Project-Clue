class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
  		t.string :title
  		t.string :image_url, :default => "http://www.standard.co.uk/incoming/article9168889.ece/alternates/w620/KETCHUP0503A.jpg"

      t.timestamps
    end
  end
end
