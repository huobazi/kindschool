class TopicEntry < ActiveRecord::Base
  attr_accessible :content, :creater_id, :status, :topic_id

  validates :topic, :creater_id, :presence => true
  validates :content, :presence => true, :length => { :minimum => 10 }
  belongs_to :topic
end
