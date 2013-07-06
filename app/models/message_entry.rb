class MessageEntry < ActiveRecord::Base
  attr_accessible :content, :message_id, :phone, :receiver_id, :receiver_name, :sms, :status

  belongs_to :message
  belongs_to :receiver, :class_name => "User",:foreign_key=>:receiver_id
end
