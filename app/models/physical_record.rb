#encoding:utf-8
class PhysicalRecord < ActiveRecord::Base
  attr_accessible :content, :creater_id, :kindergarten_id, :send_date, :student_info_id
   # attr_accessible :content_like
  just_define_datetime_picker :send_date, :add_to_attr_accessible => true

  default_scope order("created_at DESC")

  validates :content, :send_date, :student_info_id, :creater_id, :presence => true

  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :kindergarten
  belongs_to :student_info

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def student_info_label
    self.student_info ? self.student_info.user.name : "丢失学员信息"
  end
end
