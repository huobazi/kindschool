#encoding:utf-8
#班级积分
class SquadCredit < ActiveRecord::Base
  attr_accessible :credit, :kindergarten_id, :squad_id
  belongs_to :kindergarten
  belongs_to :squad
  validates :credit,:presence => true
end
