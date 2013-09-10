#encoding:utf-8
class PageImg < ActiveRecord::Base
  attr_accessible :alt, :content_entry_id, :content_type, :created_at, :filename, :height, :kindergarten_id, :parent_id, :resource_id, :resource_type, :size, :thumbnail, :width, :uploaded_data


  has_many :children, :class_name=>'PageImg', :foreign_key=>'parent_id'
  belongs_to :resource, :polymorphic => true #指定图片的类型/对象

  has_attachment :content_type => :image,
    :jpeg_quality=>75,
    :storage => :file_system,
    :max_size => 10.megabytes,
    :thumbnails => { :thumb => '206x206>', :tiny => '103x103>',:middle=>'239x177>' },
    :processor => :MiniMagick#:Rmagick
  #:resize_to => '640x360>',
  #    :thumbnails => { :thumb => '140x105>' }
  def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end
  validates_as_attachment
end
