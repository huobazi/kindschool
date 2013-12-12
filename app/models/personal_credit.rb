#encoding:utf-8
#个人积分管理
class PersonalCredit < ActiveRecord::Base
  attr_accessible :credit, :kindergarten_id, :user_id
  belongs_to :user
  belongs_to :kindergarten
  validates :credit,:presence => true
  before_save :save_credit_log
  private
  def save_credit_log
  	# CreditLog.new(:kindergarten_id=>self.kindergarten,:credit=>login_credit.credit,)

  end
end
