#encoding:utf-8
class Activity < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :end_at, :kindergarten_id, :logo, :note, :send_range, :send_range_ids, :start_at, :title, :tp

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  belongs_to :kindergarten
  has_many :activity_entries

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
