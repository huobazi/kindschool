class ProductImg < PageImg
  has_attachment :content_type => :image,
    :jpeg_quality=>75,
    :storage => :file_system,
    :max_size => 10.megabytes,
    :thumbnails => { :thumb => '400x400>', :tiny => '80x80>',:middle=>'200x200>' },
    :processor => :MiniMagick#:Rmagick
end
