#encoding:utf-8
#相册锦集
class MySchool::AlbumsController  < MySchool::ManageController
   def index
     @albums = Album.all
   end
end
