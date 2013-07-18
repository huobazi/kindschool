#encoding:utf-8
class Topic < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :is_show, :is_top, :kindergarten_id, :show_count, :status, :title, :tp, :topic_category_id

  validates :kindergarten_id, :creater_id, :topic_category_id, :title, :content, :presence => true
  validates :title, :length => { :minimum => 5 }
  validates :content, :length => { :minimum => 10 }

  belongs_to :kindergarten
  belongs_to :topic_category
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"

  has_many :topic_entries

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end


  def topic_category_label
    self.topic_category ? self.topic_category.name : "贴子分类信息丢失"
  end

end
