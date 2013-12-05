#encoding:utf-8
#个人积分管理
class PersonalCredit < ActiveRecord::Base
  attr_accessible :credit, :kindergarten_id, :user_id
  belongs_to :user
  belongs_to :kindergarten
  validates :name,:presence => true

end
