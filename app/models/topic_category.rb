#encoding:utf-8
class TopicCategory < ActiveRecord::Base
  attr_accessible :kindergarten_id, :name, :sequence

  validates :name, :presence => true, :uniqueness => { :scope => :kindergarten_id }
  validates :kindergarten_id, :presence => true

  belongs_to :kindergarten
  has_many :topics

  before_destroy :ensure_not_topic

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def ensure_not_topic
    unless self.topics.blank?
      self.topics.each do |topic|
        topic.destroy
      end
    end
  end
end
