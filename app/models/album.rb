#encoding:utf-8
class Album < ActiveRecord::Base
  attr_accessible :album_entry_id,:approve_status, :approver_id, :content, :creater_id, :grade_id, :is_show, :kindergarten_id, :send_date, :squad_id, :squad_name, :title, :tp, :is_top, :accessed_at

  belongs_to :kindergarten
  belongs_to :squad
  belongs_to :grade
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  has_many :album_entries , :dependent => :destroy
  has_many :comments , :as => :resource, :dependent => :destroy

  validates :title, :presence => true, :length => {:minimum=> 3, :maximum=> 20}

  include UnreadComment

   def show_main_img
    if self.album_entry_id && (record = self.album_entries.find_by_id(self.album_entry_id))
      album_entry = record
    else
      album_entry = self.album_entries.first unless self.album_entries.blank?
    end
    if album_entry
      asset_img = album_entry.asset_img
    end
    asset_img
   end

  def grade_label
    self.grade ? self.grade.name : "未设置年级"
  end
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def squad_label
    self.squad ? self.squad.name : "未设置班级"
  end
end
