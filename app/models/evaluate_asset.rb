#encoding:utf-8
#办公管理资源表
class EvaluateAsset < ActiveRecord::Base
  #:avatar #文件路径
  attr_accessible :kindergarten_id,:user_id,:resource_id,:resource_type,:avatar,:file_name,:file_size
  belongs_to :kindergarten
  belongs_to :user
  belongs_to :resource, :polymorphic => true
end