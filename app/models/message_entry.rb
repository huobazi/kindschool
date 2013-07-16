#encoding:utf-8
class MessageEntry < ActiveRecord::Base
  attr_accessible :content, :message_id, :phone, :receiver_id, :receiver_name, :sms, :status,:read_status

  belongs_to :message
  belongs_to :receiver, :class_name => "User",:foreign_key=>:receiver_id

  def read_status_label
    self.read_status ? "已读" : "未读"
  end
end
