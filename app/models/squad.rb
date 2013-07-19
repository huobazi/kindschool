#encoding:utf-8
#班级
class Squad < ActiveRecord::Base
  attr_accessible :grade_id, :kindergarten_id, :name, :note, :sequence,:historyreview,:graduate

  validates :name,:presence => true, :length => { :maximum => 20, :minimum => 2 }, :uniqueness => { :scope => :kindergarten_id }
  validates :kindergarten,:presence => true
  validates :note, :length => { :minimum => 5 }, :allow_blank => true

  belongs_to :kindergarten  #幼儿园
  belongs_to :grade  #年级
  has_many :student_infos  #学生信息
  has_many :users,:through=>:student_infos #学生的用户信息
  has_many :teachers
  has_many :staffs, :through => :teachers
  has_many :albums
  has_many :user_squads , :class_name=>"UserSquad" #,:conditions => "tp = 1"

  def grade_label
    self.grade ? self.grade.name : "未设置年级"
  end
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

end
