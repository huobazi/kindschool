#encoding:utf-8
#班级
class Squad < ActiveRecord::Base
  attr_accessible :grade_id, :kindergarten_id, :name, :note, :sequence,:historyreview,:graduate

  validates :name,:presence => true, :length => { :maximum => 20, :minimum => 2 }

  before_create :create_validate_name
  before_update :update_validate_name
  
  #  validates :name, :uniqueness => {:scope => :kindergarten_id , :conditions=>lambda { |table| table[:graduate] ==0 }}

  validates :kindergarten,:presence => true
  validates :note, :length => { :minimum => 5 }, :allow_blank => true

  belongs_to :kindergarten  #幼儿园
  belongs_to :grade  #年级
  has_one :career_strategy, :class_name=>"CareerStrategy",:foreign_key=>:from_id #升学策略
  
  has_many :student_infos  #学生信息
  has_many :users,:through=>:student_infos #学生的用户信息
  has_many :teachers
  has_many :staffs, :through => :teachers
  has_many :albums
  has_many :user_squads , :class_name=>"UserSquad" ,:conditions => "tp = 1"

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
  
  GRADUATE_DATA = {"true"=>"已毕业","false"=>"在读"}

  private

  def create_validate_name
    if Squad.find(:first,:select=>"1",:conditions=>["kindergarten_id=? AND name=BINARY ? AND graduate=0",self.kindergarten_id,self.name])
      errors.add(:name,"班级名称已经存在")
      raise "班级名称已经存在"
    end
  end
  def update_validate_name
    if Squad.find(:first,:select=>"1",:conditions=>["kindergarten_id=? AND name=BINARY ? AND graduate=0 and id !=?",self.kindergarten_id,self.name,self.id])
      errors.add(:name,"班级名称已经存在")
      raise "班级名称已经存在"
    end
  end

end
