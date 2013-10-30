#encoding:utf-8
#微宜平台介绍
class WeiyiConfig < ActiveRecord::Base
  attr_accessible :number, :content

  validates :number, :presence => true,:uniqueness=>true    #必须输入/不为空

  has_many :page_imgs, :class_name => "PageImg", :as => :resource, :dependent => :destroy

  attr_accessible :page_imgs_attributes
  accepts_nested_attributes_for :page_imgs
end
