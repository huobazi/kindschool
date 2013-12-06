#encoding:utf-8
#邮寄地址
class DeliveryAddress < ActiveRecord::Base
  attr_accessible :address, :address_info, :kindergarten_id, :phone, :user_id
  belongs_to :kindergarten
  belongs_to :user
  validates :phone,:presence => true
  validates :address,:presence => true
end
