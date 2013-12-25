#encoding:utf-8
#商品分类
class ProductCategory < ActiveRecord::Base
  acts_as_nested_set
  before_save :save_product_category_level
  has_many :products
  attr_accessible :name, :note, :parent_id
  validates :name,:presence => true
  private
  def save_product_category_level
     self.level = 0
     _parent = self.parent
     while !_parent.nil?
     	self.level +=1
     	_parent=_parent.parent
     end
  end
end
