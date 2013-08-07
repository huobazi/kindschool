#encoding:utf-8
class GrowthRecord < ActiveRecord::Base
  attr_accessible :content, :creater_id, :end_at, :kindergarten_id, :squad_name, :start_at, :student_info_id, :tp, :student_info, :siesta, :dine, :reward

  belongs_to :kindergarten
  belongs_to :student_info

  validates :start_at, :end_at, :presence => true
  validates :content, :length => { :minimum => 5 }
  validates :student_info_id, :presence => true

  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"

  just_define_datetime_picker :start_at, :add_to_attr_accessible => true
  just_define_datetime_picker :end_at, :add_to_attr_accessible => true
  after_create :load_messages
  
  TP_DATA = {"0"=>"宝宝在园", "1"=>"宝宝在家"}
  
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def student_info_label
    self.student_info ? self.student_info.user.name : "丢失学员信息"
  end

  def squad_name_label
    self.student_info ? self.student_info.squad.name : "丢失班级信息"
  end

  validate :end_at_large_than_start_at

  private
  #发送消息
  def load_messages
    #宝宝在家，给老师发
    if self.tp
      if self.student_info && self.student_info.squad
        squad_staffs = self.student_info.squad.staffs
        unless squad_staffs.blank?
          squad_staffs.each do |teacher|
            if teacher.user
              teacher.user.send_system_message!("#{Time.now.to_short_datetime} #{self.student_info.full_name}发布了一条宝宝在家记录","您的学生在家又有了新的表现哦，快去关注吧。")
            end
          end
        end
      end
    else
      #宝宝在园，给家长发
      if self.student_info && self.student_info.user
        self.student_info.user.send_system_message!("#{Time.now.to_short_datetime} 您有一条宝宝在园记录","您的孩子在幼儿园又有了新的表现哦，快去关注吧。")
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
