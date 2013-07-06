class TopicEntry < ActiveRecord::Base
  attr_accessible :content, :creater_id, :status, :topic_id

  validates :topic, :presence => true
  belongs_to :topic
end
