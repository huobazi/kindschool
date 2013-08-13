#encoding:utf-8
#SEO搜素关键字记录表
class ShrinkRecord < ActiveRecord::Base
  attr_accessible :description, :keywords, :kindergarten_id, :url
  belongs_to :kindergarten
end
