#encoding:utf-8
#幼儿园
class Kindergarten < ActiveRecord::Base
  attr_accessible :logo, :name, :note, :number, :status, :template_id,:weixin_code,:weixin_status,:weixin_token,:latlng,:address,
    :aliases_url,:sms_count,:sms_user_count,:telephone

  validates :name,:presence => true, :uniqueness => true, :length => { :maximum => 100}
  validates :number,:presence => true, :uniqueness => true, :length => { :maximum => 100},:exclusion => { :in => %w(www) }
  validates :note, :length => { :maximum => 800}
  STATUS_DATA = {"0"=>"正常","1"=>"锁定"}
  WEIXIN_STATUS_DATA = {"0"=>"未授权绑定","1"=>"已授权绑定"}


  def weixin_status_label
    Kindergarten::WEIXIN_STATUS_DATA[self.weixin_status.to_s]
  end

  has_many :users   #所有用户

  has_many :operates
  has_many :grades,:order=>:sequence  #年级
  has_many :grade_teachers,:through=>:grades, :source => :staff  #年级组长

  has_many :squads,:order=>[:grade_id,:sequence] #班级
  has_many :squads_teachers,:through=>:squads, :source => :teachers  #班级负责老师

  has_many :student_infos,:include=>:user,:order=>"users.name DESC",:conditions=>"users.tp=0"  #学员信息

  has_many :staff_users,:class_name=>"User",:order=>:name,:conditions=>"tp=1"
  has_many :staffs,:through=>:users,:order=>"users.name DESC",:conditions=>"users.tp=1" #

  has_one :admin, :class_name => "User", :conditions => "tp = 2" #管理员，只有一个
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy #logo，只有一个
  has_one :asset_logo, :class_name => "AssetLogo", :as => :resource, :dependent => :destroy #二维码，只有一个
  belongs_to :template

  has_many :option_operates
  has_many :operates, :through => :option_operates
  has_many :topic_entries, :through => :topics

  has_many :career_strategies
  has_many :graduate_career_strategies,:conditions=>"squads.graduate=0",:through=>:career_strategies,:source=>:from,:order=>"career_strategies.graduation DESC"

  has_many :topics

  has_many :cook_books

  has_many :notices

  has_many :messages

  has_many :growth_records

  has_many :seedling_records

  has_many :physical_records

  has_many :albums

  has_many :content_patterns

  has_many :activities

  has_many :page_contents

  has_many :roles

  has_many :topic_categories

  has_many :news

  has_many :approve_modules

  has_one :shrink_record

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img
  attr_accessible :asset_logo_attributes
  accepts_nested_attributes_for :asset_logo

  def default_template
    Template.find_by_is_default(true).id
  end


  def loading!
    PAGE_CONTENTS.each do |k,v|
      unless self.page_contents.collect(&:number).include?(k)
        self.page_contents << PageContent.new((v || {}).merge(:number=>k))
      end
    end
    #创建了幼儿园的SEO初始化
    shrink_record = ShrinkRecord.new()
    #幼儿园名字 幼儿园 幼儿园的number 幼儿园地址
    shrink_record.keywords = self.name+","+self.number+",幼儿园,"+self.address+"."
    #幼儿园名字 幼儿园 幼儿园的number 幼儿园地址
    shrink_record.description = self.name+","+self.number+",幼儿园,"+self.address+"." 
    self.shrink_record = shrink_record
    #创建所需要的审核模块
    approve_modules = YAML.load_file("#{Rails.root}/db/basic_data/approve_modules.yml")
    approve_modules.each do |k,approve_module|
     if self.approve_modules.blank? && self.approve_modules.find_by_number(approve_module[:number]).blank?
       @approve_module = ApproveModule.new(approve_module)
       @approve_module.kindergarten =self
       @approve_module.save
     end
    end
    content_entries = YAML.load_file("#{Rails.root}/db/basic_data/content_entries.yml")
    content_entries.each do |k,content_entry|
      if k == "official_website_home_news"
        @new = News.new(content_entry)
        @new.kindergarten = self
        @new.save!
      else
        page_content=self.page_contents.find_by_number(k)
        content_entry["content_entries"].each do |record|
          page_content.content_entries << ContentEntry.new(record)
        end

        page_content.save
      end
    end

    self.option_operates.each do |operate|
      operate.destroy
    end
    operates = Operate.all
    operates.each do |op|
      option_operate = OptionOperate.new(:operate_id=>op.id)
      self.option_operates << option_operate
    end

    self.roles.each  do |role|
      role.destroy
    end
    roles = YAML.load_file("#{Rails.root}/db/basic_data/role.yml")
    if !roles.blank?
      roles.each do |k,v|
        operates = v.delete("operates")
        role = Role.new(v)
        role.kindergarten = self
        unless operates.blank?
          operates.each do |operate_id|
            if option = OptionOperate.find_by_operate_id_and_kindergarten_id(operate_id,self.id)
              role.option_operates << option
            end
          end
        end
        role.save!
      end
    end
    #创建所需要的表格
    content_patterns = YAML.load_file("#{Rails.root}/db/basic_data/content_patterns.yml")
    if !content_patterns.blank?
      content_patterns.each do |k,pattern|
        unless content_pattern = self.content_patterns.where(:number=>pattern["number"]).first
          content_pattern = ContentPattern.new(pattern)
          content_pattern.kindergarten_id = self.id
          content_pattern.save
        end
      end
    end
    #创建论坛分类
    topic_categories = YAML.load_file("#{Rails.root}/db/basic_data/topic_categories.yml")
    if !topic_categories.blank?
      topic_categories.each do |k, category|
        unless topic_category = self.topic_categories.where(:name => category["name"]).first
          topic_category = TopicCategory.new(category)
          topic_category.kindergarten_id = self.id
          topic_category.save
        end
      end
    end
    self.save!
  end

  #升学验证
  def career!
    squads_data = self.graduate_career_strategies
    if squads_data.blank?
      raise "没有在读班级的升学策略。"
    else
      career_hash,new_career = {},[]
      #所有在读班级，1、进行毕业班级处理，2、进行升学班级的年级替换和名字修改成“升学中班级id”，3、添加新加班级
      squads_data.each do |squad|
        if career_strategy = squad.career_strategy
          squad_name = squad.name
          squad_grade_id = squad.grade_id
          #策略如果是毕业
          if career_strategy.graduation
            squad.update_attributes(:graduate=>true)
          else
            if to_squad = career_strategy.to
              #该升学后班级是否已经有其他班级升过
              if career_hash[to_squad.id].blank?
                career_hash[to_squad.id] = squad.id
                squad.update_attributes!(:name=>"升学中班级#{career_strategy.id}")
              else
                morge_squad = Squad.find(career_hash[to_squad.id])
                squad.student_infos.each do |student_info|
                  morge_squad.student_infos << student_info
                end
                morge_squad.save!
                squad.update_attributes!(:graduate => true)
              end
            else
              raise "错误类型2：”#{squad.full_name}”升学后班级不存在"
            end
          end

          #如果是新增班级
          if career_strategy.add_squad
            new_squad = Squad.create!(:name=>squad_name,:grade_id=>squad_grade_id,:kindergarten_id=>squad.kindergarten_id,:note=>squad.note,:sequence=>squad.sequence)
            new_career << {:kindergarten_id=>career_strategy.kindergarten_id,:graduation=>career_strategy.graduation,:add_squad=>career_strategy.add_squad,:from_id=>new_squad.id,:to_id=>squad.id}
          end
        end
      end
      
      #变化班级名字，1、对升学班级，替换成最终班级名字，2、升级策略改变
      squads_data.each do |squad|
        if career_strategy = squad.career_strategy
          unless career_strategy.graduation
            squad.update_attributes!(:grade_id=>career_strategy.to_grade_id,:name=>career_strategy.squad_name)
          end
        end
      end
      #修改策略
      squads_data.each do |squad|
        if career_strategy = squad.career_strategy
          #TODO:  修改策略
          if career_strategy.graduation
            squad.update_attributes(:grade_id=>nil)
          else
            if to_squad = career_strategy.to
              if(to_career_strategy =  to_squad.career_strategy) && to_career_strategy.graduation
                career_strategy.update_attributes!(:graduation=>to_career_strategy.graduation,:to_grade_id=>to_squad.grade_id,:squad_name=>to_squad.name)
              else
                career_strategy.update_attributes!(:to_grade_id=>to_squad.grade_id,:squad_name=>to_squad.name)
              end
            end
          end
          if career_strategy.add_squad
            career_strategy.update_attributes!(:add_squad=>false)
          end
        end
      end
      #添加新班级的策略
      CareerStrategy.create!(new_career) unless new_career.blank?
    end
  end

  #升学验证
  def career_validate
    squads_data = self.graduate_career_strategies
    data,error_message = [], []
    squads_data.each do |squad|
      if career_strategy = squad.career_strategy
        unless career_strategy.graduation
          if to_squad = career_strategy.to
            unless to_squad.career_strategy
              error_message << "错误类型1：”#{to_squad.full_name}”需要设置升学策略，否则#{squad.full_name}升学后名称重复"
            end
          else
            error_message << "错误类型2：”#{squad.full_name}”升学后班级不存在"
          end
        end
        #新增类型班级
        if career_strategy.add_squad==1
          #如果不是毕业的情况，必须还有升学班级，否则报错
          if !career_strategy.graduation && career_strategy.to.blank?
            error_message << "错误类型3：”#{squad.full_name}”属于新增班级"
          end
        end
      end
    end
    return error_message
  end

  #获取可以接收短信的用户数量
  def get_gather_sms_count
    self.users.where(:is_receive=>true).count()
  end
  #获取可以发送短信的用户数量
  def get_send_sms_count
    self.users.where(:is_send=>true).count()
  end

  #获取可用的扩展码
  def get_chain_code
    chain_users = self.users.where(:chain_delete=>true)
    unless chain_users.blank?
      return chain_users.first.chain_code
    else
      return (self.users.maximum(:chain_code) || 0) + 1
    end
  end
end
