#encoding:utf-8
require 'digest/sha1'
class User < ActiveRecord::Base
  acts_as_paranoid
  validates_as_paranoid
  attr_accessible :kindergarten_id, :logo,:login, :name, :note, :number, :status,:chain_code,
    :tp,:crypted_password,:salt,:role_id,:remember_token,:remember_token_expires_at,:chain_delete,
    :gender,:phone,:area_id,:weixin_code,:weiyi_code,:token_key,:token_secret,:token_at, :email,:is_send,:is_receive

  attr_accessible :password, :password_confirmation
  attr_accessor :password, :password_confirmation


  belongs_to :kindergarten
  has_one :student_info, :dependent => :destroy
  has_one :staff, :dependent => :destroy

  has_one :asset_logo, :class_name => "AssetLogo", :as => :resource, :dependent => :destroy #logo，只有一个
  belongs_to :role

  has_many :messages, :class_name => "Message",:foreign_key=>:sender_id

  has_many :user_squads , :class_name=>"UserSquad"

  has_many :news , :class_name=>"New"

  has_many :approve_module_users , :class_name=>"ApproveModuleUser"

  has_one  :approve_entry

  has_many :personal_sets ,:class_name=>"PersonalSet"
  
  has_many :ret_password_records

  has_many :sys_logs
   
  before_save :encrypt_password #,:automatically_generate_account

  before_create :automatically_generate_account, :unless => :role_student?


  validates :name, :length => { maximum: 20 }
  validates :password, :confirmation=> { :allow_blank=> true }, :length=>{:maximum=>20,:minimum=>6} ,:if => :password_required?
  validates :phone,:presence => true, :format=> {:with=> /^(\+\d+-)?[1-9]{1}[0-9]{10}$/, :message=> "手机格式不正确"}#{ :scope => :kindergarten_id}
  validates :name, :kindergarten_id,:presence => true
  # validates :login,:presence => true ,format: {with: /^[w][y][s]/, message: "注册名不能以#{PRE_STUDENT}"} , :if => :role_student?
  validates :login, :length=>{:maximum=>20,:minimum=>5}, :format=> {:with => /^[a-z0-9_\-@\.]*$/i,:message=>"帐号只允许使用5到20位字符的英文、数字和下划线组合"}, :if => :role_student?
  validates :login,:presence => true, :if => :role_student? #,format: {with: /^wys/, message: "注册名不能以#{PRE_STUDENT}"} , :if => :role_student?
  validates_format_of :login,:without=>/^#{PRE_STUDENT}/,:message=>"帐户不能以#{PRE_STUDENT}开头" , :if => :role_student?
  # validates :login,:presence => true,:uniqueness => true, format: {with: /^(\+\d+-)?[1-9]{1}[0-9]{10}$/, message: "手机格式不正确"}#{ :scope => :kindergarten_id}

#  validates :login, :uniqueness => true
  validates_uniqueness_of_without_deleted :login
  validates_uniqueness_of_without_deleted :email,:scope => :kindergarten_id, :allow_blank => true
  validates_uniqueness_of_without_deleted :phone,:scope => :kindergarten_id, :allow_blank => true


  GENDER_DATA = {"M"=>"女","G"=>"男"}
  TP_DATA = {"0"=>"学员","1"=>"教职工","2"=>"管理员"}
  STATUS_DATA = {"start"=>"在园","graduate"=>"毕业","leave"=>"离开","freeze"=>"冻结"}

  def automatically_generate_account
   #kind = self.kindergarten
   #user = kind.users.order("id desc").where(:tp=>0).first
   user = User.with_deleted.where(:tp=>0).order("id desc").first
   if !user.blank?
    self.login = user.login.next_number
   else
    self.login = PRE_STUDENT+"0001"
   end
  end

  def gender_label
    User::GENDER_DATA[self.gender.to_s]
  end
  def tp_label
    User::TP_DATA[self.tp.to_s]
  end

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password,kind_id)
    raise StandardError,"请输入用户名." if login.blank?
    u = find_by_login(login)
    #    if(login.include?("@"))
    #      u = find_by_login(login) # need to get the salt
    #    else
    #      u = find_by_phone(login) # need to get the salt
    #    end

    raise StandardError,"不存在该用户." unless u
    raise StandardError,"您不属于该幼儿园." if u.kindergarten_id != kind_id
    #    raise StandardError,"普通用户无法登录该系统." if (user = User.find_by_login(login) ) && user.role.number== 'user'
    #    raise "用户已被锁定,请联系系统管理员." if u.locked?
    raise StandardError,"密码错误." unless u.authenticated?(password)
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.authenticate_weiyi(login, password)
    raise StandardError,"请输入用户名." if login.blank?
    u = find_by_login(login)
    raise StandardError,"不存在该用户." unless u
    raise StandardError,"密码错误." unless u.authenticated?(password)
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(:validate => false)
  end
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{login}--#{remember_token_expires_at}")
    save(:validate => false)
  end
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def operates
    unless @operates
      @operates=[]
      if self.tp == 2
        role_operates = self.kindergarten.option_operates
      else
        role_operates = self.role.option_operates unless self.role.blank?#RoleOperate.where(:role_id=>self.role_users.collect{|ru|ru.role_id}).includes(:permission)
      end
      (role_operates|| []).each do |rr|
        @operates<<rr.operate if rr.operate
      end
    end
    @operates
  end

  def user_operates(controller_name,view_name)
    flag =false
    if operates = self.operates#.where(:controller=>controller_name,:view=>view_name).first
      operates.each do |operate|
        if operate.controller==controller_name && operate.view.include?(view_name)
          flag =true
          break;
        end
      end
    end
    return flag
  end
  #常用功能菜单
  def smarty_menu
    if role = self.role
      smarties = role.smarties
    end
    smarties
  end

  def authed_menus(t)
    mymenus = []
    root = []
    all_openrates = self.operates
    if t.blank?
      menus = Menu.find(:all,:conditions=>["(operate_id in(?) or operate_id=0)",all_openrates],:order=>"sequence asc")
    else
      menus = Menu.find(:all,:conditions=>["height_level = ? and (operate_id in(?) or operate_id=0)",t,all_openrates],:order=>"sequence asc")
    end
    menus.each do |mm|
      if root.include?(mm.root)
        mymenus.each{|item| item[:children]<< {:id=>mm.id,:number=>mm.number , :name=>mm.name , :url=>mm.url} if item[:id]==mm.root.id }
      else
        root << mm.root
        me = {:id=>mm.root.id ,:number=>mm.root.number, :name=>mm.root.name , :url=> mm.root.url , :children=>[]}
        me[:children] << {:id=>mm.id,:number=>mm.number,:name=>mm.name , :url=>mm.url}
        mymenus << me
      end
    end
    mymenus
  end


  #获取所有关联班级
  def get_users_squads
    data = self.get_users_ranges
    if data[:tp] == :all
      squads_data = self.kindergarten.squads.where(:graduate=>false)
    elsif data[:tp] == :teachers
      squads_data = []
      squads_data += data[:squads]
      unless data[:grades].blank?
        data[:grades].each do |grade|
          squads_data += grade.squads.where(:graduate=>false)
        end
      end
      unless data[:playgroup].blank?
        data[:playgroup].each do |play|
          squads_data += play.squad unless play.squad.graduate
        end
      end
    end
    squads_data.uniq!
    return squads_data.sort_by{|o| o.grade_id}
  end

  #返回tp 是all表示全部都应该能看到，
  #返回tp是teachers表示负责老师，需要根据:squads、:grades判断负责的班级和年级
  #返回tp是student表示学生
  #返回tp是only表示其他人员
  def get_users_ranges
    range_data = {}
    if self.tp == 2 || (self.tp == 1 && self.role && self.role.admin)
      range_data[:tp] = :all
    elsif self.tp == 1 #&& self.role && !self.role.admin
      range_data[:tp] = :teachers
      if self.staff
        range_data[:squads] = self.staff.squads.where(:graduate=>false)
        range_data[:grades] = self.staff.grades
        range_data[:playgroup] = self.user_squads #兴趣班
      end
    elsif self.tp == 0
      range_data[:tp] = :student
      if self.student_info
        range_data[:squad] = self.student_info.squad
        range_data[:playgroup] = self.user_squads #兴趣班
      end
    else
      range_data[:tp] = :only
    end
    return range_data
  end

  #获取用户可以发送的人
  def get_sender_users(ids=[])
    data = self.get_users_ranges
    if data[:tp] == :all
      return (self.kindergarten.users.collect{|user| user.id.to_s} & ids).uniq
    elsif data[:tp] == :teachers
      squads = data[:squads]
      unless data[:grades].blank?
        data[:grades].each do |grade|
          squads = grade.squads | squads
        end
      end
      users_ids = []
      squads.each do |squad|
        users_ids += squad.users.collect{|user| user.id.to_s}
      end
      if !data[:playgroup].blank?
        squads = data[:playgroup]
        squads.each do |squad_play|
          #添加延时班的学生和老师
          users_ids += squad_play.get_all.collect{|user_play| user_play.id.to_s}
        end
      end
      users_ids += self.kindergarten.users.where(:status=>"start",:tp=>1).collect{|user| user.id.to_s}
      return (users_ids & ids).uniq
    elsif data[:tp] == :student
      user_ids = []
      squad = data[:squad]
      #学生不考虑发年级组长
      #      if squad.grade && squad.grade.staff && (user = squad.grade.staff.user)
      #        user_ids << user.id.to_s
      #      end
      if !data[:playgroup].blank?
        squads = data[:playgroup]
        squads.each do |squad_play|
          #添加延时班的老师
          users_ids += squad_play.get_teachers.collect{|user_play| user_play.id.to_s}
        end
      end
      user_ids += squad.staffs.collect{|staff| staff.user ? staff.user.id.to_s : "0"}
      return (user_ids & ids).uniq
    else
      return []
    end
  end

  #获取未读信息
  def get_read_new_count
    Message.where("message_entries.read_status = 0 AND message_entries.deleted_at IS NULL AND messages.kindergarten_id=:kind_id AND message_entries.receiver_id=:user_id AND messages.status=:status",
      {:kind_id=>self.kindergarten_id,:user_id=>self.id,:status=>1}).joins("LEFT JOIN message_entries ON(messages.id = message_entries.message_id)").count("1")
  end

  #完整的带角色名字
  def full_name
    "#{self.role ? self.role.name : ''} #{self.name}"
  end
  
  #发送系统消息
  #消息类型为2或者3
  def send_system_message!(title,content,tp=2,resource_type=nil,resource_id=nil)
    if title && content
      message = Message.new(:title=>title,:content=>content,:tp=>tp,:send_date=>Time.now.utc,:kindergarten_id=>self.kindergarten_id,:status=>1,:resource_id=>resource_id,:resource_type=>resource_type)
      sms = 0
      sms = 1 if(tp == 2 && self.is_receive) || tp == 3
      message.message_entries << MessageEntry.new(:phone=>self.phone,:receiver_id=>self.id,:sms=>sms)
      message.save
    end
  end

  #获取微信绑定情况
  def self.get_weixin_bind_info
    user_all = User.all.count
    bind_ok = User.where("weixin_code is not null and weixin_code!=''  and weiyi_code is not null and weiyi_code!=''").count()
    bind_null = User.where("(weixin_code is null or weixin_code='')  and (weiyi_code is null or weiyi_code='')").count()
    bind_weiyi_no = User.where("weixin_code is not null and weixin_code!='' and (weiyi_code is null or weiyi_code='')").count()
    student = User.where("tp=0").count()
    woman = User.where("gender='M'").count()
    return {:man=>(user_all - woman),:woman=>woman,:teacher=>(user_all - student),:student=>student,:user_all => user_all,:bind_ok=>bind_ok,:bind_null=>bind_null,:bind_weiyi_no=>bind_weiyi_no,:bind_weixin_no=>(user_all - bind_ok - bind_null - bind_weiyi_no) }
  end
  protected
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end
  def role_student?
    self.tp != 0
  end
end
