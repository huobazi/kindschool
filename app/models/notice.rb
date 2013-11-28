#encoding:utf-8
#通知类
class Notice < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :kindergarten_id, :send_date, :send_range, :send_range_ids, :status, :title

  default_scope order("send_date DESC")

  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy

  validates :title,:content,:presence => true
  validates :send_date, :presence => true
  validate :content, :length => {maximum: 800}
  validates :title, :length => {minimum: 3, maximum: 100}

  STATUS = { 0=>"审核通过",1=> "待审核", 2=>"审核不通过"}
  SEND_RANGE_DATA ={"0"=>"全园通知","1"=>"全教职工通知","2"=>"全学生通知"}

  include ResourceApproveStatusStart
  before_save :news_approve_status_start

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def send_range_label
    Notice::SEND_RANGE_DATA["#{self.send_range || 0}"]
  end

  def change_arry_approve_record
     [:content,:title,:send_date,:send_range,:send_range_ids] 
  end

end
