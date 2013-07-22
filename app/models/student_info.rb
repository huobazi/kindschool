#encoding:utf-8
class StudentInfo < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :user_id,:birthday, :birthplace, :brothers, :card_category, :card_code, :children_number, :come_in_at, :deformity, :deformity_category, :domicile_place, :duties, :education, :employofficialt, :family_address, :family_birthday, :family_email, :family_marital, :family_name, :family_phone, :family_register, :family_ties, :grade_id, :guardian, :guardian_card_category, :guardian_card_code, :head_url, :household, :housing, :insured, :kindergarten_id, :leftover_children, :live_family, :living_time, :lodging, :nation, :nationality, :native, :only_child, :orphan, :overseas_chinese, :politics_status, :profession, :safe_box, :squad_id, :subsidize, :working
  validates :kindergarten_id,:user,:squad_id, :presence => true#

  belongs_to :user  #账户
  belongs_to :squad  #班级
  #  belongs_to :grade  #年级
  belongs_to :kindergarten  #幼儿园

  has_many :growth_records
  has_many :seedling_records
  has_many :physical_records
  has_many :student_resources

  just_define_datetime_picker :birthday, :add_to_attr_accessible => true
  just_define_datetime_picker :come_in_at, :add_to_attr_accessible => true
  just_define_datetime_picker :family_birthday, :add_to_attr_accessible => true

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def squad_label
    self.squad ? self.squad.name : "丢失班级信息"
  end

  after_create :load_role


  attr_accessible :user_attributes
  accepts_nested_attributes_for :user

  CARD_CATEGORY_DATA = {"0"=>"居民身份证","1"=>"护照","2"=>"无证件"}
  OVERSEAS_CHINESE_DATA = {"0"=>"非港澳台侨","1"=>"归侨","2"=>"华侨","3"=>"侨眷","4"=>"香港同胞","5"=>"台湾同胞","5"=>"外籍华裔人","6"=>"非华裔中国人","7"=>"外国人","8"=>"澳门同胞","9"=>"其他"}
  HOUSEHOLD_DATA ={"0"=>"农业户口","1"=>"非农业户口"}
  HOUSING_DATA = {"0"=>"购房","1"=>"自建房","2"=>"购二手房","3"=>"合法租房","4"=>"单位宿舍","5"=>"租房","6"=>"集体宿舍","7"=>"集资建房","8"=>"私建房","9"=>"购合法商品房","10"=>"福利房","11"=>"购合法集资房","12"=>"其他"}
  LIVE_FAMILY_DATA = {"0"=>"幼儿随父母居住","1"=>"幼儿随亲戚居住","2"=>"幼儿随其他人员居住"}

  def name
    self.user.name
  end

  #证件类别
  def card_category_label
    StudentInfo::CARD_CATEGORY_DATA[self.card_category.to_s]
  end

  #监护人证件类别
  def guardian_card_category_label
    StudentInfo::CARD_CATEGORY_DATA[self.guardian_card_category.to_s]
  end
  
  #港澳台侨
  def overseas_chinese_label
    StudentInfo::OVERSEAS_CHINESE_DATA[self.overseas_chinese.to_s]
  end

  #户口性质
  def household_label
    StudentInfo::HOUSEHOLD_DATA[self.household.to_s]
  end

  #住房性质
  def housing_label
    StudentInfo::HOUSING_DATA[self.housing.to_s]
  end

  #居住情况
  def live_family_label
    StudentInfo::LIVE_FAMILY_DATA[self.live_family.to_s]
  end

  #获取班级的所有老师
  def get_all_teachers
    teachers = {}
    if self.squad
      teachers[:teachers] = self.squad.staffs.where("teachers.tp=0")
      teachers[:adviser] = self.squad.staffs.where("teachers.tp=1")
      teachers[:group_leader] = self.squad.grade.staff if self.squad.grade && self.squad.grade.staff
    end
    if self.user && !self.user.user_squads.blank?
      teachers[:user_squads] = []
      self.user.user_squads.each do |user_squad|
        teachers[:user_squads] << {user_squad.squad.name=>user_squad.get_teachers} if user_squad.squad
      end
    end
    return teachers
  end

  validate :end_at_large_than_start_at

  private
  def end_at_large_than_start_at
    if !come_in_at.blank? && !birthday.blank?
      if come_in_at < birthday
        errors[:birthday] << "start_at must less than end_at"
        errors[:come_in_at] << "end_at must large than start_at"
      end
    end
  end

  #默认角色
  def load_role
    if self.user
      if role = self.kindergarten.roles.find_by_number("student")
        self.user.update_attribute(:role_id, role.id)
      end
    end
  end
end
