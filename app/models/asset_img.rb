#encoding:utf-8
require 'mime/types'
class AssetImg < ActiveRecord::Base
  attr_accessible :resource_id,:uploaded_data
  #  has_attachment  :content_type => :image, :storage => :file_system,
  #    :max_size => 1.megabytes,
  #    :thumbnails => { :thumb => '80x80>', :tiny => '40x40>' },
  #    :processor => :Rmagick
  has_many :children, :class_name=>'AssetImg', :foreign_key=>'parent_id'
  belongs_to :resource, :polymorphic => true #指定图片的类型/对象

  has_attachment :content_type => :image,
    :jpeg_quality=>75,
    :storage => :file_system,
    :max_size => 10.megabytes,
    :thumbnails => { :thumb => '480x360>', :tiny => '40x30>',:middle=>'219x145>' },
    :processor => :MiniMagick#:Rmagick
  #:resize_to => '640x360>',
  #    :thumbnails => { :thumb => '140x105>' }
  def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).join("")
    self.uploaded_data = data
  end
  validates_as_attachment
end
