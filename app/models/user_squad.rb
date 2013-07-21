#encoding:utf-8
#虚拟班的关联
class UserSquad < ActiveRecord::Base
  attr_accessible :squad_id, :user_id
  belongs_to :user
  belongs_to :squad, :conditions => "squad.tp = 1"

  validates :user_id,:squad_id,:presence => true
  validates :user_id, :uniqueness => {:scope => :squad_id}
  
end
