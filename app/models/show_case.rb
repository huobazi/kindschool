#encoding:utf-8
#展示作品
class ShowCase < ActiveRecord::Base
  attr_accessible :kindergarten_id, :creater_id, :user_id, :title, :note

  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :user
  
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy
  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  validates :title, :kindergarten, :presence => true  #必须输入/不为空

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
