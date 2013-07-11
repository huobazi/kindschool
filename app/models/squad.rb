#encoding:utf-8
#班级
class Squad < ActiveRecord::Base
  attr_accessible :grade_id, :kindergarten_id, :name, :note, :sequence,:historyreview,:graduate

  validates :name,:presence => true,:uniqueness => true
  validates :kindergarten,:presence => true

  belongs_to :kindergarten  #幼儿园
  belongs_to :grade  #年级
  has_many :student_infos  #学生信息
  has_many :users,:through=>:student_infos #学生的用户信息
  has_many :teachers
  has_many :staffs, :through => :teachers
  has_many :albums

  def grade_label
    self.grade ? self.grade.name : "未设置年级"
  end
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

end
