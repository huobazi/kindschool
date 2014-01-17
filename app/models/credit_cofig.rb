#encoding:utf-8
#积分配置
class CreditCofig < ActiveRecord::Base
  include Redis::Objects
  
  attr_accessible :credit, :name, :note, :number
  validates :credit,:presence => true
  validates :name,:presence => true
  validates :number,:presence => true
  validates :number, :uniqueness => true
  validates_format_of :number,:without=>/a-Z/,:message=>"只能填英文字母"

  after_save :load_config

  def load_config
    CreditCofig.redis.set("CreditCofig_#{self.number}",self.credit)
  end
end
