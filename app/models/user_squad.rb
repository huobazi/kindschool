#encoding:utf-8
#延时班的关联
class UserSquad < ActiveRecord::Base
  attr_accessible :squad_id, :user_id
  belongs_to :user
  belongs_to :squad, :conditions => "squads.tp = 1"

  validates :user_id,:presence => true
  validates :user_id, :uniqueness => {:scope => :squad_id}

  #获取所有人
  def get_all
    self.squad.user_squads_all_users
  end
  #获取所有老师
  def get_teachers
    self.squad.user_squads_teacher_users
  end
  #获取所有学生
  def get_students
    self.squad.user_squads_student_users
  end

end
