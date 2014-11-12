class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
  		t.string :title
  		t.string :image_url, :default => "http://dribbble.s3.amazonaws.com/users/107262/screenshots/462548/ketchup_logo_1.jpg"

      t.timestamps
    end
  end
end
