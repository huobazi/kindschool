#encoding:utf-8
#短信记录表
class SmsRecord < ActiveRecord::Base
  attr_accessible :chain_code, :status, :message_entry_id, :kindergarten_id, :sender_id,
    :sender_name,:sender_phone,:content,:receiver_id,:receiver_name,:receiver_phone

  belongs_to :kindergarten
  belongs_to :message_entry
  belongs_to :sender, :class_name => "User",:foreign_key=>:sender_id #发送人
  belongs_to :receiver, :class_name => "User",:foreign_key=>:receiver_id #接受人

  validates :kindergarten_id, :presence => true
  validates :content, :presence => true

  before_create :load_user_name

  STATUS_DATA = {"0" => "周菜谱"}#, "1" => "日菜谱"}

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  private
  def load_user_name
    if self.sender
      self.sender_name = self.sender.name
    end
    if self.receiver
      self.receiver_name = self.receiver.name
      self.receiver_phone = self.receiver.phone
    end
  end

end