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

end