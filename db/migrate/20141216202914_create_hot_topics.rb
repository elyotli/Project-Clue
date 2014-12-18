class CreateHotTopics < ActiveRecord::Migration
  def change
    create_table :hot_topics do |t|
    	t.integer :topic_id
    	t.date :date
    end
  end
end
