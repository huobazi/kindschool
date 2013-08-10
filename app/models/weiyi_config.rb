#encoding:utf-8
#微宜平台介绍
class WeiyiConfig < ActiveRecord::Base
  attr_accessible :number, :content

  validates :number, :presence => true,:uniqueness=>true    #必须输入/不为空
end
