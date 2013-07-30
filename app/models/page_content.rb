#encoding:utf-8
class PageContent < ActiveRecord::Base
  attr_accessible :tp,:kindergarten_id, :name, :number,:note,:logo_url
  validates :name,:kindergarten_id,:number,:presence => true
  validates_uniqueness_of :number,:scope=>:kindergarten_id  #同一幼儿园不允许重复
  belongs_to :kindergarten
  has_many :content_entries

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
