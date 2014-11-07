class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
  		t.string :title
  		t.string :image_url

      t.timestamps
    end
  end
end
