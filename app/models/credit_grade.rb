#encoding:utf-8
# 积分等级
# name: 名称
# credit_num: 积分值
# tp: 类型(学生或老师,管理员)
class CreditGrade < ActiveRecord::Base
  attr_accessible :credit_num, :name, :tp, :kindergarten_id

  validates :name, :kindergarten_id, :credit_num, :tp, :presence => true

  belongs_to :kindergarten

  TP_DATA = {"0" => "学员", "1" => "教职工", "2" => "管理员"}

  def tp_label
    CreditGrade::TP_DATA[self.tp.to_s]
  end
end
