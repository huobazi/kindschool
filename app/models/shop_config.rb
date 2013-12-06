class ShopConfig < ActiveRecord::Base
  attr_accessible :note, :number, :status
  validates :status,:presence => true
  validates :number,:presence => true
  validates :number, :uniqueness => true 
end
