#encoding:utf-8
class DeanEmail < ActiveRecord::Base
  attr_accessible :kindergarten_id,:status, :user_id, :content, :user_name, :user_email, :title, :return_content,:sender_id,:visible

  belongs_to :kindergarten
  belongs_to :user
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  validates :user_name, :presence => true, :length => {:maximum=> 20}
  validates :user_email, :presence => true, :length => {:maximum=> 100}, :format => /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
  validates :title, :presence => true, :length => {:maximum=> 20}
  validates :content, :presence => true, :length => {:maximum=> 400}
  validates :return_content, :length => {:maximum=> 400}

  before_save :load_status

  STATUS_DATA = {"0"=>"未回复","1"=>"已回复"}
  VISIBLE_DATA = {"false"=>"未公布","true"=>"已公布"}

  def status_label
    DeanEmail::STATUS_DATA[self.status.to_s]
  end
  def visible_label
    DeanEmail::VISIBLE_DATA[self.visible.to_s]
  end

  def load_status
    if self.return_content.blank?
      self.status = 0
    else
      self.status = 1
    end
  end

end