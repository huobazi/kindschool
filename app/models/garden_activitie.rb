#encoding:utf-8
#园讯通官活动发布
class GardenActivitie < ActiveRecord::Base
  attr_accessible :content, :title,:start_at,:end_at,:note
  
  has_many :page_imgs, :class_name => "PageImg", :as => :resource, :dependent => :destroy
  default_scope order("created_at desc")
  
  validates :title,:presence=>true
  validates :title, :length => {:maximum => 200}
  
  attr_accessible :page_imgs_attributes
  accepts_nested_attributes_for :page_imgs
  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true
end
