#encoding:utf-8
#模板
class Template < ActiveRecord::Base
  attr_accessible :name, :number, :is_default,:image_url

  has_many :kindergartens

end
