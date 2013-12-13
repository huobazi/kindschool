#encoding:utf-8
#积分日志
class CreditLog < ActiveRecord::Base
  attr_accessible :business_id, :business_type, :credit, :kindergarten_id, :note, :resource_id, :resource_type, :tp
  belongs_to :kindergarten
  belongs_to :resource, :polymorphic => true #记学生或者是班级或者是幼儿园的
  belongs_to :business, :polymorphic => true #业务上面的积分来源
  validates :credit,:presence => true
  TP = { 0=>"每天登陆加分",1=>"反馈信息加分" ,2=>"成长记录加分" ,3=>"百度解答加分",4=>"作业完成加分",5=>"作业评定加分",6=>"班级加分",7=>"幼儿园加分",8=>"积分消费"}
end
