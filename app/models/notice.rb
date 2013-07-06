#encoding:utf-8
#通知类
class Notice < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :kindergarten_id, :send_date, :send_range, :send_range_ids, :status, :title

  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  validates :title,:content,:presence => true

  
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  SEND_RANGE_DATA ={"0"=>"全园通知","1"=>"年级通知","2"=>"班级通知","3"=>"全教职工通知"}
  def send_range_label
    Notice::SEND_RANGE_DATA["#{self.send_range || 0}"]
  end


end
