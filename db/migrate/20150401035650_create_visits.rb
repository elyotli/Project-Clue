class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
    	t.belongs_to :topic
    	t.timestamp
    end
  end
end
