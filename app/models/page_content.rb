#encoding:utf-8
class PageContent < ActiveRecord::Base
  attr_accessible :tp,:kindergarten_id, :name, :number,:note,:logo_url
  belongs_to :kindergarten
  has_many :content_entries

  validates :name,:kindergarten_id,:number,:presence => true
  validates_uniqueness_of :number,:scope=>:kindergarten_id  #同一幼儿园不允许重复

  TP = {0 => '页面', 1 => '官网'}

  def tp_label
    PageContent::TP[self.tp]
  end

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
