#encoding:utf-8
#幼儿园
class Kindergarten < ActiveRecord::Base
  attr_accessible :logo, :name, :note, :number, :status, :template_id,:weixin_code,:weixin_status,:weixin_token

  validates :name,:presence => true, :uniqueness => true, :length => { :maximum => 100}
  validates :number,:presence => true, :uniqueness => true, :length => { :maximum => 100}
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
  belongs_to :template

  has_many :option_operates
  has_many :operates, :through => :option_operates

  has_many :career_strategies

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

  attr_accessible :asset_img_attributes
  accepts_nested_attributes_for :asset_img

  def default_template
    Template.find_by_is_default(true).id
  end


  def loading!
    PAGE_CONTENTS.each do |k,v|
      unless self.page_contents.collect(&:number).include?(k)
        self.page_contents << PageContent.new((v || {}).merge(:number=>k))
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

      self.roles.delete_all
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
          puts pattern.inspect
         unless content_pattern = self.content_patterns.where(:number=>pattern["number"]).first
            content_pattern = ContentPattern.new(pattern)
            content_pattern.kindergarten_id = self.id
            content_pattern.save
          end
        end 
      end
    self.save!
  end
end
