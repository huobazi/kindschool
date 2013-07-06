#encoding:utf-8
#教职工
class Staff < ActiveRecord::Base
  attr_accessible :user_id, :card_code, :attendance_code, :education, :birthday, :come_in_at

  belongs_to :user
  has_many :teachers, :dependent => :destroy
  has_many :squads, :through => :teachers #关联管理的班级
  has_many :grades  #年级组长，管理对应的年级


  validates :user, :presence => true
  attr_accessible :user_attributes
  accepts_nested_attributes_for :user

  def name
     self.user ? self.user.name : "账户信息不存在"
  end

  just_define_datetime_picker :birthday, :add_to_attr_accessible => true
  just_define_datetime_picker :come_in_at, :add_to_attr_accessible => true
  def kindergarten_label
    if self.user && self.user.kindergarten
      self.user.kindergarten.name
    else
      "缺少幼儿园信息"
    end
  end
end
