#encoding:utf-8
class GrowthRecord < ActiveRecord::Base
  attr_accessible :content, :creater_id, :end_at, :kindergarten_id, :squad_name, :start_at, :student_info_id, :tp, :student_info

  belongs_to :kindergarten
  belongs_to :student_info

  validates :start_at, :end_at, :presence => true
  validates :content, :length => { :minimum => 5 }
  validates :student_info, :presence => true

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def student_info_label
    self.student_info ? self.student_info.user.name : "丢失学员信息"
  end

  def squad_name_label
    self.student_info ? self.student_info.squad.name : "丢失班级信息"
  end

  validate :end_at_large_than_start_at

  private

  def end_at_large_than_start_at
    if !end_at.blank? && !start_at.blnak?
      if end_at < start_at
        errors[:start_at] << "start_at must less than end_at"
        errors[:end_at] << "end_at must large than start_at"
      end
    end
  end

end
