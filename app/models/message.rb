#encoding:utf-8
class Message < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :approve_status, :approver_id, :chain_code, :content, :entry_id,
    :kindergarten_id, :parent_id, :send_date, :sender_id, :sender_name, :status, :title, :tp

  belongs_to :kindergarten
  belongs_to :sender, :class_name => "User",:foreign_key=>:sender_id
  has_many :message_entries

  #回复的信息
  has_many :return_messages, :class_name => "Message",:foreign_key=>:entry_id,:order=>"send_date DESC", :dependent => :destroy
  belongs_to :parent_message, :class_name => "Message",:foreign_key=>:entry_id

  validates :content,:sender_id,:send_date, :presence => true
  validates :title, :presence => {:if => :if_return?}

  validates :content, :length => { :minimum => 1 }

  STATUS_DATA = {"0"=>"草稿","1"=>"已发送"}
  #系统提示消息，开通短信，将受到短信；
  #系统短信消息，所有人都将收到短信；
  TP_DATA = {"0"=>"站内信","1"=>"站内加短信","2"=>"系统提示消息","3"=>"系统短信消息"}
  
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy


  include ResourceApproveStatusStart
  before_save :news_approve_status_start

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  #已读状态
  def read_status_count
    self.message_entries.where(:read_status=>1).count()
  end

  before_create :load_user_info


  before_save :load_sms_records


  #是否是回复的
  def if_return?
    self.entry_id.blank?
  end

  private
  #创建是加载
  def load_user_info
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
  
  #创建和更新时加载
  def load_sms_records
    if self.status && self.tp == 1
      if self.id_was
        #更新的情况
        self.message_entries.where("deleted_at IS NULL").each do |entry|
          if entry.receiver.is_receive
            role = self.sender.role if self.sender && self.sender.role
            if self.approve_status == 0 && entry.sms_record.blank?
              entry.sms_record =  SmsRecord.new(:chain_code=>self.chain_code,:sender_id=>self.sender_id,
                :sender_name=>self.sender_name,:content=>"#{self.title} #{self.content} #{role ? (role.name + '-') : ''}#{self.sender ? self.sender.name : ''}",:receiver_id=>entry.receiver.id,
                :receiver_name=>entry.receiver.name,:receiver_phone=>entry.receiver.phone,:kindergarten_id=>self.kindergarten_id)
            end
          end
        end
      else
        #创建的情况
        self.message_entries.each do |entry|
          if entry.receiver.is_receive
            role = self.sender.role if self.sender && self.sender.role
            if self.approve_status == 0 && entry.sms_record.blank?
              entry.sms_record =  SmsRecord.new(:chain_code=>self.chain_code,:sender_id=>self.sender_id,
                :sender_name=>self.sender_name,:content=>"#{self.title} #{self.content} #{role ? (role.name + '-') : ''}#{self.sender ? self.sender.name : ''}",:receiver_id=>entry.receiver.id,
                :receiver_name=>entry.receiver.name,:receiver_phone=>entry.receiver.phone,:kindergarten_id=>self.kindergarten_id)
            end
          end
        end
      end
    end
  end
end
