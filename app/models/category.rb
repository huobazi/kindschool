#encoding:utf-8
#资料库分类
class Category < ActiveRecord::Base
  attr_accessible :name, :tp, :visible

  validates :name, :presence => true,:uniqueness=>true    #必须输入/不为空
  TP_DATA = {"0"=>"微信资料库","1"=>"点评资料库","2"=>"家长关注"}
  
end
