#encoding:utf-8
class SeedlingRecord < ActiveRecord::Base
  attr_accessible :creater_id, :expire_at, :kindergarten_id, :name, :note, :shot_at, :student_info_id

  just_define_datetime_picker :shot_at, :add_to_attr_accessible => true
  just_define_datetime_picker :expire_at, :add_to_attr_accessible => true

  validates :name, :presence => true, :uniqueness => true
  validates :note, :length => { :minimum => 5 }, :presence => true
  validate :shot_at, :expire_at, :presence => true

  belongs_to :student_info
  belongs_to :kindergarten
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  validate :end_at_large_than_start_at
  private
  def end_at_large_than_start_at
    if !expire_at.blank? && !shot_at.blank?
      if expire_at < shot_at
        errors[:shot_at] << "shot_at must less than end_at"
        errors[:expire_at] << "expire_at must large than start_at"
      end
    end
  end
end
