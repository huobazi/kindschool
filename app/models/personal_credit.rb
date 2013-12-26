#encoding:utf-8
#个人积分管理
class PersonalCredit < ActiveRecord::Base
  attr_accessible :credit, :kindergarten_id, :user_id, :heap_credit
  belongs_to :user
  belongs_to :kindergarten

  validates :credit, :kindergarten, :presence => true

  before_save :save_credit_log
  after_save :save_heap_credit

  def credit_grade_tp_label
    user.tp_label if user && user.tp
  end

  def credit_grade_name
    if user && user.tp && c = CreditGrade.find(user.tp)
      credit_num_str = c.credit_num.split('~')
      if credit >= credit_num_str[0].to_i && credit <= credit_num_str[1].to_i
        c.name
      end
    end
  end

  private
  def save_credit_log
  	# CreditLog.new(:kindergarten_id=>self.kindergarten,:credit=>login_credit.credit,)

  end

  def save_heap_credit
    self.heap_credit ||= 0
    if self.credit > self.heap_credit
      self.heap_credit = self.credit
      self.save
    end
  end

end
