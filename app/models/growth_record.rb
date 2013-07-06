#encoding:utf-8
class GrowthRecord < ActiveRecord::Base
  attr_accessible :content, :creater_id, :end_at, :kindergarten_id, :squad_name, :start_at, :student_info_id, :tp

  belongs_to :kindergarten
  belongs_to :student_info

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  validate :end_at_large_than_start_at

  private

  def end_at_large_than_start_at
    if end_at < start_at
      errors[:start_at] << "start_at must less than end_at"
      errors[:end_at] << "end_at must large than start_at"
    end
  end

end
