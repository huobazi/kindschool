#encoding:utf-8
class Message < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :chain_code, :content, :entry_id, :kindergarten_id, :parent_id, :send_date, :sender_id, :sender_name, :status, :title, :tp

  belongs_to :kindergarten
  belongs_to :sender, :class_name => "User",:foreign_key=>:sender_id
  has_many :message_entries


  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
