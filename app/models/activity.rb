#encoding:utf-8
class Activity < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :end_at, :kindergarten_id, :logo, :note, :send_range, :send_range_ids, :start_at, :title, :tp, :squad_id
  before_save :activities_approve_status_start

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  validates :title, :content, :start_at, :end_at, :tp, :presence => true
  validates :title, :length => { :minimum => 3 }
  validates :content, :length => { :minimum => 5 }

  belongs_to :kindergarten
  has_many :activity_entries
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy #logo，只有一个
  belongs_to :squad

  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
 
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

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
  protected
  def activities_approve_status_start
    if kind =  self.kindergarten
      if approve_module=kind.approve_modules.find_by_number("activities")
         if approve_module.status
           if self.approve_status_was == self.approve_status
            self.approve_status = 1
            if self.approve_record.blank?
               approve_record = ApproveRecord.new()
               self.approve_record = approve_record
               approve_entry=ApproveEntry.new(:note=>"创建了一条活动信息")
               self.approve_record.approve_entries << approve_entry
            else
               self.approve_record.status = 1
               approve_entry=ApproveEntry.new(:note=>"更新了该条活动信息")
               self.approve_record.approve_entries << approve_entry
            end
           end
         end
      end
    end    
  end
end
