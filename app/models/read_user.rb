#encoding:utf-8
#阅读人员记录
class ReadUser < ActiveRecord::Base
  attr_accessible :kindergarten_id,:resource_id,:user_id,:user_name,:resource_type,:resource_id
  belongs_to :resource, :polymorphic => true #指定图片的类型/对象
  belongs_to :user
  belongs_to :kindergarten

end
