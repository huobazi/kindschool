#encoding:utf-8
#园讯通官网新闻的发布
class GardenNew < ActiveRecord::Base
  attr_accessible :content, :creater_id, :note, :title
  belongs_to :creater, :class_name => "AdminUser",:foreign_key=>:creater_id
  
  has_many :page_imgs, :class_name => "PageImg", :as => :resource, :dependent => :destroy
  default_scope order("created_at desc")
  validates :title,:content,:presence=>true
  validates :title,:note, :length => {:maximum => 200}
  
  attr_accessible :page_imgs_attributes
  accepts_nested_attributes_for :page_imgs
  just_define_datetime_picker :created_at, :add_to_attr_accessible => true
end
