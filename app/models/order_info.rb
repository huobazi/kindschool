#encoding:utf-8
#订单详细
class OrderInfo < ActiveRecord::Base
  attr_accessible :address, :address_info, :amount, :comment, :count, :credit, :kindergarten_id, :order_id, :phone, :product_id, :quality, :delivery_address_id
  belongs_to :order
  belongs_to :product
  belongs_to :delivery_address
  belongs_to :kindergarten
  validates :phone,:presence => true
  validates :address,:presence => true
  def self.for_product(product)
     item = self.new
     item.count = 1
     item.product = product
     #商品的单价
     item.amount = product.price
     item
   end
end
