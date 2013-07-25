#encoding:utf-8
class Activity < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :end_at, :kindergarten_id, :logo, :note, :send_range, :send_range_ids, :start_at, :title, :tp

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  validates :title, :content, :start_at, :end_at, :tp, :presence => true
  validates :title, :length => { :minimum => 3 }
  validates :content, :length => { :minimum => 5 }

  belongs_to :kindergarten
  has_many :activity_entries
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy #logo，只有一个

  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def last_page
    page = (self.activity_entries.count.to_f / 10).ceil
    page > 1 ? page : nil
  end
end
