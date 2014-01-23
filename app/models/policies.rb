class Policies < ActiveRecord::Base
  attr_accessible :content, :kind_zone_id, :title

  belongs_to :kind_zone
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  validates :title, :content, :presence => true
end
