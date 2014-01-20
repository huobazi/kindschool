#encoding:utf-8
#商品
class Product < ActiveRecord::Base
  attr_accessible :product_storage,:storage,:approve_id, :credit, :description, :keywords, :market_price,:img_id,
    :meaning, :name, :price, :product_category_id, :shop_id, :status, :user_id,:merchant_id,
    :view_asset_id,:note
  belongs_to :product_category

  
  validates :keywords,:presence => true
  validates :market_price,:presence => true
  validates :price,:presence => true
  validates :name,:presence => true
  validates :credit,:presence => true
  validates :keywords,:presence => true
  validates :status,:presence => true

  acts_as_taggable
  scope :by_join_date, order("created_at DESC")

  scope :descend_by_credit, order("credit DESC")
  scope :descend_by_price, order("price DESC")
  scope :ascend_by_credit, order("credit ASC")
  scope :ascend_by_price, order("price ASC")

  STATUS_DATA = {"0"=>"下架","1"=>"待审核","2"=>"上架","3"=>"无货"}
  SHOP_DATA = {"0"=>"学生商城","1"=>"幼儿园商城"}


  has_many :product_imgs, :class_name => "ProductImg", :as => :resource, :dependent => :destroy
  belongs_to :img, :class_name => "ProductImg"
  belongs_to :merchant
  has_many :product_storages

  attr_accessible :product_imgs_attributes
  accepts_nested_attributes_for :product_imgs

  before_save  :change_products_status   #更改了就进行修改状态

  def get_head_img
    self.img.blank? ? self.product_imgs.first : self.img
  end

  def product_storage
     self.storage
  end

  def product_storage=(str)
    if !self.product_storages.blank? 
      self.product_storages<<ProductStorage.new(:count=>str.to_i-self.storage,:note=>"编辑商品改了库存")
    else
      self.product_storages<<ProductStorage.new(:count=>str.to_i,:note=>"编辑商品改了库存")
    end 
    self.storage = str.to_i
  end

  def self.user_credit(credit)
    self.where("credit < #{credit}")
  end

  protected
  #add by zhangfang
  #修改商品后进行修改状态
  def change_products_status
    if self.name_changed? || self.price_changed?  || self.credit_changed? || self.description_changed?
      self.status = 1
      # self.save
    end
  end

end
