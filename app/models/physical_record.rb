#encoding:utf-8
class PhysicalRecord < ActiveRecord::Base
  attr_accessible :content, :creater_id, :kindergarten_id, :send_date, :student_info_id

  just_define_datetime_picker :send_date, :add_to_attr_accessible => true

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  validates :content, :send_date, :presence => true

  belongs_to :kindergarten
  belongs_to :student_info
end
