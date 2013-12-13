#encoding:utf-8
#商品分类
class ProductCategory < ActiveRecord::Base
  attr_accessible :name, :note, :parent_id
  validates :name,:presence => true
end
