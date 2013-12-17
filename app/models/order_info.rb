#encoding:utf-8
#订单详细
class OrderInfo < ActiveRecord::Base
  attr_accessible :amount, :comment, :count, :credit, :kindergarten_id, :order_id,  :product_id, :quality
  belongs_to :order
  belongs_to :product
  belongs_to :kindergarten
  def self.for_product(product)
     item = self.new
     item.count = 1
     item.product = product
     item.credit = product.credit
     #商品的单价
     item.amount = product.price
     item
   end
end
