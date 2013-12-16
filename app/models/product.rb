#encoding:utf-8
class Product < ActiveRecord::Base
  attr_accessible :approve_id, :credit, :description, :keywords, :market_price,
    :meaning, :name, :price, :product_category_id, :shop_id, :status, :user_id,
    :view_asset_id
  belongs_to :product_category
  validates :keywords,:presence => true
  validates :market_price,:presence => true
  validates :price,:presence => true
  validates :name,:presence => true
  validates :keywords,:presence => true
  validates :status,:presence => true

  acts_as_taggable
  scope :by_join_date, order("created_at DESC")

  scope :descend_by_credit, order("credit DESC")
  scope :descend_by_price, order("price DESC")
  scope :ascend_by_credit, order("credit ASC")
  scope :ascend_by_price, order("price ASC")

  STATUS_DATA = {"0"=>"下架","1"=>"待审核","2"=>"上架","3"=>"无货"}


end
