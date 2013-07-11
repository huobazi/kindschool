#encoding:utf-8
class TopicCategory < ActiveRecord::Base
  attr_accessible :kindergarten_id, :name

  validates :name, :presence => true, :uniqueness => true
  validates :kindergarten_id, :presence => true

  belongs_to :kindergarten
  has_many :topics

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end
end
