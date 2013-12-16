#encoding:utf-8
#订单
class Order < ActiveRecord::Base
  attr_accessible  :delivery_address_id,:phone,:address, :address_info,:amount, :credit, :express_code, :kindergarten_id, :note, :number, :postage, :shipment_at, :status, :user_id
  belongs_to :kindergarten
  belongs_to :user
  has_many :order_infos#, :class_name=>"OrderInfo"
  validates :status,:presence => true
  validates :number,:presence => true
  validates :number, :uniqueness => true
  validates :phone,:presence => true
  validates :address,:presence => true

end
