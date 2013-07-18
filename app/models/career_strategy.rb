#encoding:utf-8
class CareerStrategy < ActiveRecord::Base
  attr_accessible :add_squad, :from_id, :graduation, :kindergarten_id, :to_id,:squad_name

  belongs_to :kindergarten

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
