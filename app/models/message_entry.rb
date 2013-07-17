#encoding:utf-8
class MessageEntry < ActiveRecord::Base
  attr_accessible :content, :message_id, :phone, :receiver_id, :receiver_name, :sms, :status,:read_status

  belongs_to :message
  belongs_to :receiver, :class_name => "User",:foreign_key=>:receiver_id

  validates :receiver_id, :presence => true

  def read_status_label
    self.read_status ? "已读" : "未读"
  end

  def before_create
    if self.receiver
      self.receiver_name = self.receiver.name
    elsif self.receiver_id
      if user = User.find_by_id_and_kindergarten_id(self.receiver_id,self.kindergarten_id)
        self.receiver_name = user.name
      end
    end
  end
end
