#encoding:utf-8
class Product < ActiveRecord::Base
  attr_accessible :approve_id, :credit, :description, :keywords, :market_price, :meaning, :name, :price, :product_category_id, :shop_id, :status, :user_id, :view_asset_id
  belongs_to :product_category
end
