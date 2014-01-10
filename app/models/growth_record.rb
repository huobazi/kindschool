#encoding:utf-8
#成长记录
class GrowthRecord < ActiveRecord::Base
  attr_accessible :content, :creater_id, :end_at, :kindergarten_id, :squad_name, 
    :start_at, :student_info_id, :tp, :student_info, :siesta, :dine, :reward, :accessed_at,:audio_turn

  default_scope order("created_at DESC")
  scope :week_stat, ->(start_at, end_at) { where("start_at >= ? and end_at <= ?", start_at, end_at) }

  validates :start_at, :end_at, :presence => true
  validates :content, :length => { :minimum => 5 }
  validates :student_info_id, :presence => true
  validates :siesta, :length => { :maximum=> 50 }, :allow_blank => true
  validates :dine, :length=> {:maximum=> 50}, :allow_blank => true
  validates :reward, :numericality=> true
  validate_harmonious_of :content

  belongs_to :kindergarten
  belongs_to :student_info
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :student, :class_name => "User", :foreign_key => "student_info_id"
  has_many :comments, :as => :resource
  has_many :asset_imgs, :class_name => "AssetImg", :as => :resource, :dependent => :destroy
  # has_many :messages
  has_many   :credit_logs,:class_name=>"CreditLog", :as => :business


  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true

  after_create :load_messages
  before_destroy :ensure_not_comments

  TP_DATA = {"false"=>"宝宝在园", "true"=>"宝宝在家"}

  def ensure_not_comments
    unless self.comments.blank?
      self.comments.each do |comment|
        comment.visible = false
        comment.save
      end
    end
  end

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def student_info_label
    self.student_info ? self.student_info.user.name : "该学员不存在或已删除"
  end

  def squad_name_label
    self.student_info ? self.student_info.squad.name : "该班级不存在或已删除"
  end

  validate :end_at_large_than_start_at

  def full_growth_record_title
    str = ""
    if self.tp = true
      str = "#{self.student_info_label}的宝宝在家成长记录"
    else
      str = "#{self.student_info_label}的宝宝在园成长记录"
    end
  end
  def full_growth_record_content
    str = ""
    if self.tp == true
      str += "类型:宝宝在家"
    else
      str += "类型:宝宝在园"
    end
    str += "<div class='growth_record_time'>开始时间:<i>#{self.start_at.try(:to_short_datetime)}</i></div>"
    str += "<div class='growth_record_time'>结束时间:<i>#{self.end_at.try(:to_short_datetime)}</i></div>"
    str += "<div class='growth_record_content'>#{self.content}</div>"
    str += "<div class='spra'>";

    unless self.asset_imgs.blank?
      self.asset_imgs.each do |img|
        str += "<a href='#{img.public_filename(:thumb)}' class='fancybox' title='#{self.student_info_label}'>"
        str += "<img src='#{img.public_filename(:middle)}' />"
        str += "</a>"
      end
    end
    str += "</div>"
  end

  include UnreadComment

  private
  #发送消息
  def load_messages
    #宝宝在家，给老师发
    hint_tp = self.kindergarten.hint_tp
    if self.tp
      if self.student_info && self.student_info.squad
        squad_staffs = self.student_info.squad.staffs
        unless squad_staffs.blank?
          squad_staffs.each do |teacher|
            if teacher.user
              teacher.user.send_system_message!("#{Time.now.to_short_datetime} #{self.student_info.full_name}发布了一条宝宝在家记录","您的学生在家又有了新的表现哦，快去关注吧。",4,self.class.to_s,self.id)
            end
          end
        end
      end
    else
      #宝宝在园，给家长发
      if self.student_info && self.student_info.user
        self.student_info.user.send_system_message!("#{Time.now.to_short_datetime} 您有一条宝宝在园记录","您的孩子在幼儿园又有了新的表现哦，快去关注吧.",(hint_tp ? 3 : 2),self.class.to_s,self.id)
      end
    end
  end
  def end_at_large_than_start_at
    if !end_at.blank? && !start_at.blank?
      if end_at < start_at
        errors[:start_at] << "start_at must less than end_at"
        errors[:end_at] << "end_at must large than start_at"
      end
    end
  end

end
