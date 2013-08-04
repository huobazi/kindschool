#encoding:utf-8
#微信资料库
class WeixinDatabank < ActiveRecord::Base
  attr_accessible :title, :content, :category_id,:visible,:creater_id
  belongs_to :category,:conditions=>"tp=0"
  belongs_to :creater, :class_name => "AdminUser", :foreign_key => "creater_id"
  has_many :weixin_shares, :class_name => "WeixinShare",:foreign_key=>"weixin_databank_id"
  
  validates :title,:category_id,:content, :presence => true  #必须输入/不为空
end
