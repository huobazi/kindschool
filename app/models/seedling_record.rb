#encoding:utf-8
class SeedlingRecord < ActiveRecord::Base
  attr_accessible :creater_id, :expire_at, :kindergarten_id, :name, :note, :shot_at, :student_info_id

  just_define_datetime_picker :shot_at, :add_to_attr_accessible => true
  just_define_datetime_picker :expire_at, :add_to_attr_accessible => true

  belongs_to :student_info
  belongs_to :kindergarten

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
