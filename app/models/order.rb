#encoding:utf-8
#订单
class Order < ActiveRecord::Base
  attr_accessible :amount, :credit, :express_code, :kindergarten_id, :note, :number, :postage, :shipment_at, :status, :user_id
  belongs_to :kindergarten
  belongs_to :user
  validates :status,:presence => true
  validates :number,:presence => true
  validates :number, :uniqueness => true

end
