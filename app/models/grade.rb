#encoding:utf-8
#年级
class Grade < ActiveRecord::Base
  attr_accessible :kindergarten_id, :name, :note, :sequence,:staff_id

  validates :name,:presence => true,:uniqueness => { :scope => :kindergarten_id}, :length => { :maximum => 20 }
  validates :kindergarten,:sequence,:presence => true
  validate_harmonious_of :note

  belongs_to :kindergarten #幼儿园
  belongs_to :staff        #年级组长
  has_many :squads,:order=>:sequence #班级
#  has_many :student_infos  #学生信息 已遗弃
  has_many :albums

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def student_infos_count
    self.squads.sum{|squad| squad.student_infos.count}
  end

end
