#encoding:utf-8
#新闻的发布
class News < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :create_id, :kindergarten_id, :note, :title
  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User",:foreign_key=>:create_id
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy
  default_scope order("created_at desc")
  validates :title, :length => { :minimum => 3 }
  validates :content, :length => { :minimum => 3 }
  STATUS = { 0=>"审核通过",1=> "待审核", 2=>"审核不通过"}

  include ResourceApproveStatusStart
  before_save :news_approve_status_start
end
