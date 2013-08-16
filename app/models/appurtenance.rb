#encoding:utf-8
# require 'file_size_validator'
class Appurtenance < ActiveRecord::Base
  # attr_accessible :title, :body
  # CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:].-+]/ 
  mount_uploader :avatar, AvatarUploader
  attr_accessible :file_size,:file_name,:avatar, :avatar_cache,:resource_id, :resource_type, :user_id
  # validates :avatar, :file_size => {  :maximum => 6.megabytes.to_i, message: "您上传的附件已超过6M,请重新上传"}
  belongs_to :resource, :polymorphic => true #指定图片的类型/对象
  belongs_to :user
  validate :file_size

  def file_size
    if avatar.file.size.to_f/(1000*1000) > 5.0
      errors.add(:avatar, "您上传的附件#{avatar.file.original_filename}不能超过5M.")
    end
  end
end
