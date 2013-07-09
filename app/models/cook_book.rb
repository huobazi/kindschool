#encoding:utf-8
class CookBook < ActiveRecord::Base
  attr_accessible :content, :creater_id, :end_at, :kindergarten_id, :range_tp, :start_at

  belongs_to :kindergarten

  validates :kindergarten_id, :presence => true

  # just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  # just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  RANGE_TP_DATA = {"0" => "周菜谱", "1" => "日菜谱"}

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
