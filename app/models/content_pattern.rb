#encoding:utf-8
class ContentPattern < ActiveRecord::Base
  attr_accessible :content, :kindergarten_id, :number

  belongs_to :kindergarten

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
