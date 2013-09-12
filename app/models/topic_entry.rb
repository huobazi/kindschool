class TopicEntry < ActiveRecord::Base
  attr_accessible :content, :creater_id, :status, :topic_id,:goodback

  validates :topic, :creater_id, :presence => true
  validates :content, :presence => true, :length => { :minimum => 3 }
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :topic

  #设置精品回帖
  def set_goodback(tp="0")
    if tp == "1"
      self.update_attribute(:goodback, true)
    else
      self.update_attribute(:goodback, false)
    end
  end
end
