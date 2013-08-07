#encoding:utf-8
#评论功能
class Comment < ActiveRecord::Base
  attr_accessible :kindergarten_id,:visible,:parent_id,:user_id,:resource_id,:resource_type,:comment

  validates :comment,:user_id, :presence => true  #必须输入/不为空
  belongs_to :resource, :polymorphic => true #指定图片的类型/对象
  belongs_to :user
  belongs_to :kindergarten
  belongs_to :parent, :class_name => "Comment", :foreign_key => "parent_id" #所回复的
  
end
