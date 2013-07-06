class ActivityEntry < ActiveRecord::Base
  attr_accessible :activity_id, :creater_id, :note, :tp

  belongs_to :activity

  has_one :activity_img, :class_name => "ActivityImg", :as => :resource, :dependent => :destroy

  attr_accessible :activity_img_attributes
  accepts_nested_attributes_for :activity_img
end
