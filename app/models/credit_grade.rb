#encoding:utf-8
# 积分等级
# name: 名称
# down_credit: 积分下限
# up_credit: 积分上限
# tp: 类型(学生或老师,管理员)
class CreditGrade < ActiveRecord::Base
  attr_accessible :down_credit, :up_credit, :name, :tp

  validates :name, :down_credit, :up_credit, :tp, :presence => true
  validate :up_credit, :must_large_than_down_credit

  has_one :page_img, :class_name => "PageImg", :as => :resource, :dependent => :destroy

  attr_accessible :page_img_attributes
  accepts_nested_attributes_for :page_img


  TP_DATA = {"0" => "学员", "1" => "教职工", "2" => "管理员"}

  def tp_label
    CreditGrade::TP_DATA[self.tp.to_s]
  end

  def credit_label
    "#{down_credit}~#{up_credit}" if down_credit? && up_credit?
  end

  protected
  def must_large_than_down_credit
    if down_credit? && up_credit? && down_credit >= up_credit
      errors.add(:up_credit, "积分上限的值必须大于积分下限的值")
    end
  end
end
