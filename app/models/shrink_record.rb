#encoding:utf-8
#SEO搜素关键字记录表
class ShrinkRecord < ActiveRecord::Base
  attr_accessible :description, :keywords, :kindergarten_id, :url
  belongs_to :kindergarten
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
