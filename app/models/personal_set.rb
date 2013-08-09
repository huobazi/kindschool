#encoding:utf-8
#个人锦集
class PersonalSet < ActiveRecord::Base
  default_scope order("created_at desc")
  attr_accessible :resource_id, :resource_type, :user_id
  belongs_to :user
  belongs_to :resource, :polymorphic => true #指定图片的类型/对象

end
