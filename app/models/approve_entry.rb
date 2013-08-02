#encoding:utf-8
#审核记录
class ApproveEntry < ActiveRecord::Base
  attr_accessible :approve_record_id, :note, :status, :user_id
  belongs_to :user
  belongs_to :approve_record
  STATUS = { 1=>"审核通过",0=> "待审核", 2=>"审核不通过"}
end
