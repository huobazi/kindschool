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
  

  def self.verification_import(file,kind_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    exist_phone = []
    phone = []
    unexist_squads = []
    number = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["手机号码"].blank? || row["班级名称"].blank?
        number = i 
      end
        phone << row["手机号码"].to_i
        if user = User.find_by_phone(row["手机号码"].to_i)
          exist_phone << user.phone
        end
        unless squads = Squad.find_by_name_and_kindergarten_id(row["班级名称"],kind_id)
          unexist_squads << row["班级名称"]
        end
    end
    repeat_phone=phone.dups
    if !number.blank? || !exist_phone.blank? || !unexist_squads.blank? || !repeat_phone.blank?
      return number,exist_phone,unexist_squads,repeat_phone
    end
  end

  def self.import(file,kind_id)
    spreadsheet = open_spreadsheet(file)
    user_password = []
    header = spreadsheet.row(1)
      StudentInfo.transaction do
       (2..spreadsheet.last_row).each do |i|
         row = Hash[[header, spreadsheet.row(i)].transpose]  
            user=User.new()
            student_info = StudentInfo.new()
            user.phone = row["手机号码"].to_i.to_s
            user.name = row["姓名"]
            user.kindergarten_id = kind_id
            student_info.kindergarten_id = kind_id
            user.gender = row["性别"]=="男" ?  "G" : "M"
            #给user生成帐号跟密码
            #user.login =
            password = Standard.rand_password
            user.password = password
            student_info.birthday = row["出生日期"]
            if row["证件类型"] == "居民身份证"
             student_info.card_category = 0
            elsif row["证件类型"] == "护照"
             student_info.card_category = 1 
            else
             student_info.card_category = 2
            end
            student_info.card_code = row["证件号码"].to_s   
            student_info.family_address = row["现住址"]
            student_info.come_in_at = row["入园日期"]
            student_info.guardian = row["监护人姓名"]
            student_info.guardian_card_code = row["监护人身份证号码"].to_s
            student_info.user = user
            squad = Squad.find_by_name_and_kindergarten_id(row["班级名称"],kind_id)
            student_info.squad = squad
            student_info.save!
            user_password << {:user=>user,:password=>password}
          end
      end
      user_password.each do |u_password|
        user = u_password[:user]
        password = u_password[:password]
        title = "您已经成功注册了微壹幼儿园校讯通平台"
        content = "您的登录名:#{user.login},密码:#{password}"
        user.send_system_message!(title,content,3)
      end
      # raise ""
  end

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

  def full_name
    "#{self.squad ? self.squad.name : ''} #{self.name}"
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
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
     end
  end
end
