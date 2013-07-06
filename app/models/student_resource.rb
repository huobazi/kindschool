class StudentResource < ActiveRecord::Base
  attr_accessible :student_info_id
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy
  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  belongs_to :student_info
end
