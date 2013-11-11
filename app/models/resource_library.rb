#encoding:utf-8
#后台资源库
class ResourceLibrary < ActiveRecord::Base
  attr_accessible :file_name, :file_size, :resource_avatar, :user_id
  mount_uploader :resource_avatar, ResourceAvatarUploader
  
end
