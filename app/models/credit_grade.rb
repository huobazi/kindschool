#encoding:utf-8
# 积分等级
# name: 名称
# credit_num: 积分值
# tp: 类型(学生或老师,管理员)
class CreditGrade < ActiveRecord::Base
  attr_accessible :credit_num, :name, :tp

  validates :name, :credit_num, :tp, :presence => true
  validates :credit_num, format: { with: /\A\d+~\d+\Z/, message: "必须包含数字加~(波浪线)数字,不能包含空格,例如0~50000"}

  has_one :page_img, :class_name => "PageImg", :as => :resource, :dependent => :destroy

  attr_accessible :page_img_attributes
  accepts_nested_attributes_for :page_img


  TP_DATA = {"0" => "学员", "1" => "教职工", "2" => "管理员"}

  def tp_label
    CreditGrade::TP_DATA[self.tp.to_s]
  end
end
