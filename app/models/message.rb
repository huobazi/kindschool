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

  validates :content, :length => { :minimum => 5 }

  STATUS_DATA = {"0"=>"草稿","1"=>"已发送"}
  TP_DATA = {"0"=>"站内信","1"=>"站内加短信"}

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def before_create
    if self.sender
      self.sender_name = self.sender.name
    elsif self.sender_id
      if user = User.find_by_id_and_kindergarten_id(self.sender_id,self.kindergarten_id)
        self.sender_name = user.name
      end
    end
  end

  before_save :load_sms_records


  #是否是回复的
  def if_return?
    self.entry_id.blank?
  end

  private
  def load_sms_records
    if !self.status_was && self.status && self.tp == 1
      self.message_entries.where("deleted_at IS NULL").each do |entry|
        if entry.receiver.is_receive
          entry.sms_record =  SmsRecord.new(:chain_code=>self.chain_code,:sender_id=>self.sender_id,
            :sender_name=>self.sender_name,:content=>"#{self.content}",:receiver_id=>entry.receiver.id,
            :receiver_name=>entry.receiver.name,:receiver_phone=>entry.receiver.phone,:kindergarten_id=>self.kindergarten_id)
        end
      end
    end
  end
end
