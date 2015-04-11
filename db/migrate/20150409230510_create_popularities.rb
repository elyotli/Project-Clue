class CreatePopularities < ActiveRecord::Migration
  def change
    create_table :popularities do |t|
    	t.belongs_to	:topic
    	t.integer		:index
  		t.date 	  		:date
  		t.integer		:status

      	t.timestamps
    end
  end
end
