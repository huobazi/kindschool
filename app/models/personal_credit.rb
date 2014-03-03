#encoding:utf-8
#个人积分管理
class PersonalCredit < ActiveRecord::Base
  attr_accessible :prize_credit,:credit, :kindergarten_id, :user_id, :heap_credit
  belongs_to :user
  belongs_to :kindergarten

  validates :credit, :kindergarten, :presence => true

  before_save :save_credit_log
  after_save :save_heap_credit
  after_save :save_prize_credit


  def credit_grade_tp_label
    user.tp_label if user && user.tp
  end

  def credit_grade_name
    credit_grade.name if credit_grade.name
  end

  def credit_grade
    CreditGrade.where("tp = ? and down_credit <= ? and up_credit >= ?", user.tp, credit, credit).first if user && user.tp
  end

  def credit_grade_label
    credit_grade.credit_label
  end

  private
  def save_credit_log
    # CreditLog.new(:kindergarten_id=>self.kindergarten,:credit=>login_credit.credit,)

  end

  def save_prize_credit
     self.prize_credit ||= 0 
     if self.kindergarten
        if credit_cofig=CreditCofig.find_by_number('prize_credit')
          prize_credit = credit_cofig.credit
          if self.heap_credit_changed? #&& self.heap_credit-self.prize_credit>prize_credit
            count =(self.heap_credit-self.prize_credit)/prize_credit
            count.to_i.times do |i|
             self.prize_credit += prize_credit
             prize_log=PrizeLog.new(:user_id=>self.user_id,:kindergarten_id=>self.kindergarten_id,)
             prize_log.stage_credit=self.prize_credit
             prize_log.save
            end
          end
        end
     end
  end

  def save_heap_credit
    self.heap_credit ||= 0
    if self.credit > self.heap_credit
      self.heap_credit = self.credit
      self.save
    end
  end

end
