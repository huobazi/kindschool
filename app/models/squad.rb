#encoding:utf-8
#班级
class Squad < ActiveRecord::Base
  attr_accessible :grade_id, :kindergarten_id, :name, :note, :sequence,:historyreview,:graduate,:tp

  validates :name,:presence => true, :length => { :maximum => 20, :minimum => 2 }

  before_create :create_validate_name
  before_update :update_validate_name
  
  #  validates :name, :uniqueness => {:scope => :kindergarten_id , :conditions=>lambda { |table| table[:graduate] ==0 }}

  validates :kindergarten,:presence => true
  validates :note, :length => { :minimum => 5 }, :allow_blank => true

  belongs_to :kindergarten  #幼儿园
  belongs_to :grade  #年级
  has_one :career_strategy, :class_name=>"CareerStrategy",:foreign_key=>:from_id #升学策略
  has_many :source_career_strategies, :class_name=>"CareerStrategy",:foreign_key=>:to_id #升学策略

  has_many :student_infos  #学生信息
  has_many :users,:through=>:student_infos #学生的用户信息
  has_many :teachers
  has_many :staffs, :through => :teachers
  has_many :albums
  has_many :user_squads , :class_name=>"UserSquad"
  has_many :user_squads_all_users,:through=>:user_squads,:source=>:user #所有延时班的人
  has_many :user_squads_teacher_users,:through=>:user_squads,:source=>:user,:conditions => "users.tp = 1 OR users.tp = 2" #所有延时班的老师
  has_many :user_squads_student_users,:through=>:user_squads,:source=>:user,:conditions => "users.tp = 0"  #所有延时班的学生

  has_many :activities
  has_many :topics

  has_many :topics

  def full_name
    "#{self.grade ? self.grade.name + "-" : ""}#{self.name}"
  end

  def grade_label
    self.grade ? self.grade.name : "未设置年级"
  end
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def is_graduate?
    false
  end

  def class_teacher
    if teacher = self.teachers.find_by_tp(1)
      teacher.staff.user.name
    else
      "没有班主任"
    end
  end

  GRADUATE_DATA = {"true"=>"已毕业","false"=>"在读"}

  private

  def create_validate_name
    if Squad.find(:first,:select=>"1",:conditions=>["kindergarten_id=? AND name=BINARY ? AND graduate=0",self.kindergarten_id,self.name])
      errors.add(:name,"班级名称已经存在")
      raise "班级名称已经存在"
    end unless self.graduate
  end
  def update_validate_name
    if Squad.find(:first,:select=>"1",:conditions=>["kindergarten_id=? AND name=BINARY ? AND graduate=0 and id !=?",self.kindergarten_id,self.name,self.id])
      errors.add(:name,"班级名称已经存在")
      raise "班级名称已经存在"
    end unless self.graduate
  end
end
