#encoding:utf-8
#奖品表
class Prize < ActiveRecord::Base
  attr_accessible :beep, :beep_url, :content, :content_url, :name, :status
  mount_uploader :content_url, ContentUrlUploader

end
