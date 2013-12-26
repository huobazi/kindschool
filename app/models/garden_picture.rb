#encoding:utf-8
#园讯通官网照片集锦
class GardenPicture < ActiveRecord::Base
  attr_accessible :tp, :title

  has_one :page_img, :class_name => "PageImg", :as => :resource, :dependent => :destroy

  default_scope order("created_at desc")
  validates :title,:presence=>true
  validates :title, :length => {:maximum => 200}

  attr_accessible :page_img_attributes
  accepts_nested_attributes_for :page_img

end
