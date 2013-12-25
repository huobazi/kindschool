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

  NATION={"01"=>"汉族","02"=>"蒙古族","03"=>"回族","04"=>"藏族","05"=>"维吾尔族","06"=>"苗族","07"=>"彝族","08"=>"壮族","09"=>"布依族","10"=>"朝鲜族","11"=>"满族","12"=>"侗族","13"=>"瑶族","14"=>"白族","15"=>"土家族","16"=>"哈尼族","17"=>"哈萨克族","18"=>"傣族","19"=>"黎族","20"=>"傈傈族","21"=>"佤族","22"=>"畲族","23"=>"高山族","24"=>"拉祜族","25"=>"水族","26"=>"东乡族","27"=>"纳西族","28"=>"景颇族","29"=>"柯尔克孜族","30"=>"土族","31"=>"达斡族","32"=>"仫佬族","33"=>"羌族","34"=>"布朗族","35"=>"撒拉族","36"=>"毛南族","37"=>"仡佬族","38"=>"锡伯族","39"=>"阿昌族","40"=>"普米族","41"=>"塔吉克族","42"=>"怒族","43"=>"乌孜别克族","44"=>"俄罗斯族","45"=>"鄂温克族","46"=>"崩龙族","47"=>"保安族","48"=>"裕固族","49"=>"京族","50"=>"塔塔尔族","51"=>"独龙族","52"=>"鄂伦春族","53"=>"赫哲族","54"=>"门巴族","55"=>"珞巴族","56"=>"基诺族","57"=>"中籍外国血统","98"=>"其他"}
  FAMILY_REGISTER={"11"=>"深户","13"=>"暂住","31"=>"无户口","41"=>"港澳","42"=>"台湾","43"=>"外国" }
  NATIONALITY={"236"=>"中国","400"=>"其他"}
  CHILDREN_NUMBER={1=>"独生子女",2=>"第一胎（指未办独生子女证",3=>"计划内第一胎",4=>"计划内第二胎",5=>"超生但办理了罚款手续",6=>"超生未办理罚款手续"}


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
        phone << row["手机号码"].gsub!(/\s*$/, '')
        # if user = User.find_by_phone(row["手机号码"].gsub!(/\s*$/, ''))
        #   exist_phone << user.phone
        # end
        unless squads = Squad.find_by_name_and_kindergarten_id(row["班级名称"],kind_id)
          unexist_squads << row["班级名称"]
        end
    end
    repeat_phone=[]  #phone.dups
    if !number.blank? || !exist_phone.blank? || !unexist_squads.blank? #|| !repeat_phone.blank?
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
      if kind =Kindergarten.find_by_id(kind_id)
        login_note = kind.login_note
      end
      user_password.each do |u_password|
        user = u_password[:user]
        password = u_password[:password]
        kind = user.kindergarten
        title = "您已经成功注册了#{kind.name}微壹校讯通平台"
        if kind.aliases_url.blank?
         web_address = "http://#{kind.number}.#{WEBSITE_CONFIG["web_host"]}"
        else
         web_address = kind.aliases_url
        end
        content = "您的登录名：#{user.login},密码：#{password},登录地址：#{web_address} "
        user.send_system_message!("系统消息","#{title},#{content} #{login_note}",3)
      end
      # raise ""
  end


  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def squad_label
    self.squad ? self.squad.name : "丢失班级信息"
  end
  def grade_label
    self.squad && self.squad.grade ? self.squad.grade.name : "丢失年级信息"
  end

  after_create :load_role


  attr_accessible :user_attributes
  accepts_nested_attributes_for :user

  CARD_CATEGORY_DATA = {"0"=>"居民身份证","1"=>"护照","2"=>"无证件"}
  OVERSEAS_CHINESE_DATA = {"0"=>"非港澳台侨","1"=>"归侨","2"=>"华侨","3"=>"侨眷","4"=>"香港同胞","5"=>"台湾同胞","5"=>"外籍华裔人","6"=>"非华裔中国人","7"=>"外国人","8"=>"澳门同胞","9"=>"其他"}
  HOUSEHOLD_DATA ={"0"=>"农业户口","1"=>"非农业户口"}
  HOUSING_DATA = {"0"=>"购房","10"=>"自建房","11"=>"购二手房","12"=>"合法租房","13"=>"单位宿舍","2"=>"租房","3"=>"集体宿舍","4"=>"集资建房","5"=>"私建房","7"=>"购合法商品房","8"=>"福利房","9"=>"购合法集资房","6"=>"其他"}
  LIVE_FAMILY_DATA = {"1"=>"幼儿随父母居住","2"=>"幼儿随亲戚居住","3"=>"幼儿随其他人员居住"}

  def name
    self.user ? self.user.name : ""
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
