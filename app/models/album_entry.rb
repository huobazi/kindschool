class AlbumEntry < ActiveRecord::Base
  attr_accessible :title,:album_id, :asset_img_id
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy

  belongs_to :album

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img
end
