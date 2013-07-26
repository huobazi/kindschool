#encoding:utf-8
#新闻的发布
class News < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :create_id, :kindergarten_id, :note, :title
  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User",:foreign_key=>:create_id
  default_scope order("created_at desc") 
  validates :title, :length => { :minimum => 3 }
  validates :content, :length => { :minimum => 3 }
end
