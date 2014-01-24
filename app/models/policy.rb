class Policy < ActiveRecord::Base
  attr_accessible :content, :kind_zone_id, :title, :kind_zone_ids

  has_and_belongs_to_many :kind_zones
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  validates :title, :content, :presence => true

  def kind_zones_label
    kind_zones.map do |kind_zone|
      kind_zone.zone_name
    end.join("  ")
  end
end
