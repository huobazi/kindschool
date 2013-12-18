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
  def mark_as_shipped
    if self.user && self.user.personal_credit  &&  self.user.personal_credit.credit >= self.credit
      self.shipment_at = Time.zone.now
      credit_value  = self.user.personal_credit.credit - self.credit
      self.user.personal_credit.update_attributes(:credit=>credit_value)
      tp = 8 #"积分消费"
      credit_log = CreditLog.new(:kindergarten_id=>self.kindergarten_id,:credit=>self.credit,:tp=>tp)
      credit_log.business = self
      self.user.credit_logs << credit_log
    end
  end

end
