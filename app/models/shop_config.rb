class ShopConfig < ActiveRecord::Base
  attr_accessible :note, :number, :status,:name
  validates :status,:name,:number,:presence => true
  validates :number, :uniqueness => true

  #多张图片
  has_many :page_imgs, :class_name => "PageImg", :as => :resource, :dependent => :destroy
  attr_accessible :page_imgs_attributes
  accepts_nested_attributes_for :page_imgs

  #单张图片
  has_one :page_img, :class_name => "PageImg", :as => :resource, :dependent => :destroy
  attr_accessible :page_img_attributes
  accepts_nested_attributes_for :page_img
end
