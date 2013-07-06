#encoding:utf-8
class Topic < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :is_show, :is_top, :kindergarten_id, :show_count, :squad_id, :status, :title, :tp

  validates :kindergarten_id, :presence => true

  belongs_to :kindergarten
  belongs_to :squad

  has_many :topic_entries

  def squad_label
    self.squad ? self.squad.name : "未设置班级"
  end

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

end
