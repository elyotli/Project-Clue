class CreateDayTopics < ActiveRecord::Migration
  def change
    create_table :day_topics do |t|
  	  t.integer :topic_id
  	  t.integer :day_id

      t.timestamps
    end
  end
end
