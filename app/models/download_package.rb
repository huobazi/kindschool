#encoding:utf-8
#评估系统下载包
class DownloadPackage < ActiveRecord::Base
  attr_accessible :status,:kindergarten_id, :name, :package
  belongs_to :kindergarten
  # mount_uploader :package, PackageUploader

end
