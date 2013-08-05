#encoding:utf-8
#微信资料库发布分享的阅读记录
class WeixinShareUser < ActiveRecord::Base
  attr_accessible :weixin_share_id, :user_id,:kindergarten_id,:read_status,:read_at


  belongs_to :weixin_share
  belongs_to :user
  belongs_to :kindergarten
  validates :user_id, :presence => true   #必须输入/不为空


  def read_status_label
    self.read_status ? "已读" : "未读"
  end
end
