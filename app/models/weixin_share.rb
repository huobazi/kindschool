#encoding:utf-8
#微信资料库发布分享
class WeixinShare < ActiveRecord::Base
  attr_accessible :weixin_databank_id, :send_date,:visible,:send_range
  belongs_to :weixin_databank
  just_define_datetime_picker :send_date, :add_to_attr_accessible => true
  
  has_many :weixin_share_users, :class_name => "WeixinShareUser",:foreign_key=>"weixin_share_id"

  
  validates :send_date, :presence => true   #必须输入/不为空

  SEND_RANGE_DATA = {"0"=>"所有学生","1"=>"所有学生和老师"}
end
