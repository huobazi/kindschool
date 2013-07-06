#encoding:utf-8
class Album < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :grade_id, :is_show, :kindergarten_id, :send_date, :squad_id, :squad_name, :title, :tp

  belongs_to :kindergarten
  belongs_to :squad
  belongs_to :grade
  has_many :album_entries


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
