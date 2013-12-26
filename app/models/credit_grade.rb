#encoding:utf-8
# 积分等级
# name: 名称
# credit_num: 积分值
# tp: 类型(学生或老师,管理员)
class CreditGrade < ActiveRecord::Base
  attr_accessible :credit_num, :name, :tp

  validates :name, :credit_num, :tp, :presence => true
  validates :credit_num, format: { with: /\A\d+~\d+\Z/, message: "必须包含数字加~(波浪线)数字,不能包含空格,例如0~50000"}

  TP_DATA = {"0" => "学员", "1" => "教职工", "2" => "管理员"}

  def tp_label
    CreditGrade::TP_DATA[self.tp.to_s]
  end
end
