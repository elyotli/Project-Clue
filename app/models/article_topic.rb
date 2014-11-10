class ArticleTopic < ActiveRecord::Base
	belongs_to :topic
	belongs_to :article
end
