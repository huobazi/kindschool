#encoding:utf-8
#微信资料库发布分享
class WeixinShare < ActiveRecord::Base
  attr_accessible :weixin_databank_id, :send_at,:visible
  validates :weixin_databank_id,:send_at, :presence => true   #必须输入/不为空

  belongs_to :weixin_databank
  
end
