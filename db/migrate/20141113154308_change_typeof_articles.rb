class ChangeTypeofArticles < ActiveRecord::Migration
  def change
  	change_column :articles, :title, :text
  	change_column :articles, :url, :text
  	change_column :articles, :source, :text
  	change_column :articles, :image_url, :text
  end
end
