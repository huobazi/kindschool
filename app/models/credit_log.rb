#encoding:utf-8
#积分日志
class CreditLog < ActiveRecord::Base
  attr_accessible :business_id, :business_type, :credit, :kindergarten_id, :note, :resource_id, :resource_type, :tp
  belongs_to :kindergarten
  belongs_to :resource, :polymorphic => true #记学生或者是班级或者是幼儿园的
  belongs_to :business, :polymorphic => true #业务上面的积分来源
  validates :credit,:presence => true
  
end
