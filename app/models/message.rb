#encoding:utf-8
class Message < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :approve_status, :approver_id, :chain_code, :content, :entry_id,
    :kindergarten_id, :parent_id, :send_date, :sender_id, :sender_name, :status, :title, :tp,:allsms
  belongs_to :kindergarten
  belongs_to :sender, :class_name => "User",:foreign_key=>:sender_id
  has_many :message_entries

  #回复的信息
  has_many :return_messages, :class_name => "Message",:foreign_key=>:entry_id,:order=>"send_date DESC", :dependent => :destroy
  belongs_to :parent_message, :class_name => "Message",:foreign_key=>:entry_id

  validates :content,:send_date, :presence => true
  validates :sender_id,:presence => {:if=>:if_sernder?}
  validates :title, :presence => {:if => :if_return?}

  validates :content, :length => { :minimum => 1 }

  STATUS_DATA = {"0"=>"草稿","1"=>"已发送"}
  #系统提示消息，开通短信，将受到短信；
  #系统短信消息，所有人都将收到短信；
  TP_DATA = {"0"=>"站内信","1"=>"站内加短信","2"=>"系统提示消息","3"=>"系统短信消息","4"=>"系统站内消息"}
  
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy

  STATUS = { 0=>"审核通过",1=> "待审核", 2=>"审核不通过"}


  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  #已读状态
  def read_status_count
    self.message_entries.where(:read_status=>1).count()
  end

  before_create :load_user_info
  before_save :load_allsms_count
  include ResourceApproveStatusStart
  before_save :messages_approve_status_start
  before_save :load_sms_records


  

  #是否是回复的
  def if_return?
    self.entry_id.blank?
  end

  #是否需要发送人
  def if_sernder?
    [0,1].include?(self.tp)
  end
  
  #该消息是否已经回复
  def is_retrun?(user_id)
    is_retrun = self.return_messages.where(:sender_id=>user_id).first
    unless is_retrun.blank?
      return true
    else
      return false
    end
  end
  #该消息回复记录
  def is_retrun(user_id)
    is_retrun = self.return_messages.where(:sender_id=>user_id)
  end

  private
  #创建是加载
  def load_user_info
    if [2,3,4].include?(self.tp)
      self.sender_name = "系统消息"
    else
      if self.sender
        self.sender_name = self.sender.name
        self.chain_code  = self.sender.chain_code
      elsif self.sender_id
        if user = User.find_by_id_and_kindergarten_id(self.sender_id,self.kindergarten_id)
          self.sender_name = user.name
          self.chain_code  = user.chain_code
        end
      end
    end
  end
  
  #创建和更新时加载
  def load_sms_records
    if self.status
      if [1,2,3].include?(self.tp)
        if self.id_was
          message_entries_data =  self.message_entries.where("deleted_at IS NULL")
        else
          message_entries_data =  self.message_entries
        end
        message_entries_data.each do |entry|
          if([1,2].include?(self.tp) && (self.allsms || entry.receiver.is_receive)) || self.tp == 3
            role = self.sender.role if self.sender && self.sender.role
            if self.approve_status == 0 && entry.sms_record.blank?
              entry.sms_record =  SmsRecord.new(:chain_code=>self.chain_code,:sender_id=>self.sender_id,
                :sender_name=>self.sender_name,:content=>"#{self.title} #{self.content} #{role ? (role.name + '-') : ''}#{self.sender_name}",:receiver_id=>entry.receiver.id,
                :receiver_name=>entry.receiver.name,:receiver_phone=>entry.receiver.phone,:kindergarten_id=>self.kindergarten_id)
            end
          end
        end
      end
    end
  end

  #判断群发短信数量是否足够
  def load_allsms_count
    if curr_kindergarten = self.kindergarten || Kindergarten.find_by_id(self.kindergarten_id)
      unless curr_kindergarten.begin_allsms
        if(self.id_was && !self.status_was && self.status) || self.status
          errors.add(:content,"您的幼儿园短信群发已关闭！")
          raise "您的幼儿园短信群发已关闭！"
        end
      end
      if curr_kindergarten.open_allsms
        #如果是编辑
        if self.id_was
          if !self.status_was && self.status
            if curr_kindergarten.get_allsms_count == 0
              errors.add(:content,"您的幼儿园的本月群发短信条数次数不足！")
              raise "您的幼儿园的本月群发短信条数次数不足！"
            end
          end
        else
          #这是新增
          if self.status
            if curr_kindergarten.get_allsms_count == 0
              errors.add(:content,"您的幼儿园的本月群发短信条数次数不足！")
              raise "您的幼儿园的本月群发短信条数次数不足！"
            end
          end
        end
      end
    else
      errors.add(:content,"所属幼儿园不存在")
      raise "所属幼儿园不存在"
    end
  end
end
