#encoding:utf-8
class Activity < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :end_at, :kindergarten_id, :logo, :note, :send_range, :send_range_ids, :start_at, :title, :tp, :squad_id

  default_scope order("created_at DESC")

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  validates :title, :content, :start_at, :end_at, :tp, :presence => true
  validates :title, :length => { :minimum => 3, :maximum => 100 }
  validates :content, :length => { :minimum => 5 }

  belongs_to :kindergarten
  has_many :activity_entries
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy #logo，只有一个
  belongs_to :squad

  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
 
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  before_destroy :ensure_not_activity_entries

  STATUS = { 0=>"审核通过",1=> "待审核", 2=>"审核不通过"}

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def last_page
    page = (self.activity_entries.count.to_f / 10).ceil
    page > 1 ? page : nil
  end

  def squad_label
    self.squad ? self.squad.name : "没有班级信息"
  end
  
  def change_arry_approve_record
     [:content,:title, :end_at,:note, :send_range, :send_range_ids,:squad_id, :start_at] 
  end

  include ResourceApproveStatusStart
  before_save :news_approve_status_start

  def ensure_not_activity_entries
    unless self.activity_entries.blank?
      self.activity_entries.each do |activity_entry|
        activity_entry.is_show = false
        activity_entry.save
      end
    end
  end

  validate :end_at_cannot_be_in_the_past, if: Proc.new { |c| c.tp }

  def end_at_cannot_be_in_the_past
    if end_at.present? && end_at.tomorrow < Time.now
      errors.add(:end_at, "结束时间不能小于当前时间")
    end
  end
end
