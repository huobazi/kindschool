class TopicEntry < ActiveRecord::Base
  attr_accessible :content, :creater_id, :status, :topic_id

  validates :topic, :creater_id, :presence => true
  validates :content, :presence => true, :length => { :minimum => 10 }
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :topic
end
