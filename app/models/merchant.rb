#encoding:utf-8
#商家
class Merchant < ActiveRecord::Base
  attr_accessible :name, :note, :logo_id

  validates :name,:presence => true, :length => { :maximum => 20 }

  

end
