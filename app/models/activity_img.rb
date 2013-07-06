class ActivityImg < ActiveRecord::Base
  attr_accessible :alt, :content_type, :created_at, :filename, :height, :parent_id, :resource_id, :resource_type, :size, :thumbnail, :width, :uploaded_data

  has_many :children, :class_name=>'ActivityImg', :foreign_key=>'parent_id'
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
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end
  validates_as_attachment
end
