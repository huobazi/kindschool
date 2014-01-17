class ProductImg < PageImg
  has_attachment :content_type => :image,
    :jpeg_quality=>75,
    :storage => :file_system,
    :max_size => 10.megabytes,
    :thumbnails => { :thumb => '540x345>', :tiny => '90x58>',:middle=>'180x115>' },
    :processor => :MiniMagick#:Rmagick
end
