#encoding:utf-8
class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:role_name
  # attr_accessible :title, :body
  
  ROLE_NAME_DATA = {"admin"=>"管理员","operation"=>"运营","bazaar"=>"市场","member"=>"成员"}

  def role_name_label
    AdminUser::ROLE_NAME_DATA[self.role_name.to_s]
  end
end
