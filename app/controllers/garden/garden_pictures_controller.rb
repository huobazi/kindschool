#encoding:utf-8
#园讯通照片集锦
class Garden::GardenPicturesController < Garden::BaseController
  def index
    @garden_pictures = GardenPicture.all
  end
end
