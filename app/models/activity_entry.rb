#encoding:utf-8
class ActivityEntry < ActiveRecord::Base
  attr_accessible :activity_id, :creater_id, :note, :tp, :is_show

  belongs_to :activity

  validates :note, :activity_id, :creater_id, :presence => true
  validates :note, :length => { minimum: 3 }

  has_one :activity_img, :class_name => "ActivityImg", :as => :resource, :dependent => :destroy
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"

  attr_accessible :activity_img_attributes
  accepts_nested_attributes_for :activity_img

  def is_show_label
    is_show ? "是" : "否"
  end

end
