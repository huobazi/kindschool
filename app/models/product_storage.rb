#encoding:utf-8
#商品库存日志
class ProductStorage < ActiveRecord::Base
  attr_accessible :count, :note, :product_id, :tp
  belongs_to :product
end
