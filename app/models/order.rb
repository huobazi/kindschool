#encoding:utf-8
#订单
class Order < ActiveRecord::Base
  attr_accessible  :delivery_address_id,:phone,:address, :address_info,:amount, :credit, :express_code, :kindergarten_id, :note, :number, :postage, :shipment_at, :status, :user_id
  belongs_to :kindergarten
  belongs_to :user
  has_many :order_infos#, :class_name=>"OrderInfo"
  belongs_to :delivery_address
  validates :status,:presence => true
  validates :number,:presence => true
  validates :number, :uniqueness => true
  validates :phone,:presence => true
  validates :address,:presence => true

  def self.pending_shipping
  	where("shipment_at is null")
  end
  
  def product_storage_off
   if self.order_infos
    self.order_infos.each do |info|
      product=info.product
      storage = product.storage
      product.update_attribute(:storage,storage-info.count)
      product.product_storages<<ProductStorage.new(:count=>0-info.count,:note=>"下订单")
      product.save
    end
   end 
  end

  def product_storage_able
    if self.order_infos
      self.order_infos.each do |info|
        count_product =info.product.product_storages.select("sum(count) as oo ")
       if count_product.first.oo.to_i < info.count
         return info.product
       end 
      end
      return false
    end
  end

  def mark_as_shipped
    if self.user && self.user.personal_credit  &&  self.user.personal_credit.credit >= self.credit
      self.shipment_at = Time.zone.now
      credit_value  = self.user.personal_credit.credit - self.credit
      self.user.personal_credit.update_attributes(:credit=>credit_value)
      tp = 8 #"积分消费"
      self.status = 1 #表示订单状态发生了改变
      credit_log = CreditLog.new(:kindergarten_id=>self.kindergarten_id,:credit=>self.credit,:tp=>tp)
      credit_log.business = self
      self.user.credit_logs << credit_log
    end
  end

end
