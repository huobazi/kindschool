#encoding:utf-8
#教学计划
class TeachingPlan < ActiveRecord::Base
  attr_accessible :content, :creater_id, :kindergarten_id, :squad_id, :title
  default_scope order("created_at desc")
  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :squad
  has_many :appurtenances, :class_name => "Appurtenance", :as => :resource, :dependent => :destroy

  validates :content, :presence => true, length: {minimum: 3}
  validates :title, :presence => true, length: {maximum: 20}

end
