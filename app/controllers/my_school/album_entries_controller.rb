#encoding:utf-8
#相册
class MySchool::AlbumEntriesController < MySchool::ManageController
   def create
   	 @album = @kind.albums.find(params[:album_id])
   	 @album_entry = @album.album_entries.new(params[:album_entry]) 
   	 flag = false
   	 unless params[:uploaded_data].blank?
   	 	puts "11111111111\n\n\n\n"
   	 	puts params[:uploaded_data].inspect
      @album_entry.asset_img = AssetImg.new(:uploaded_data=>params[:uploaded_data])
      flag = true
     end
     respond_to do |format|
     unless flag
      if @album_entry.save && @album_entry.asset_img.save
        format.html { redirect_to my_school_albums_path, notice: '图片上传 was successfully created.' }
      else
        format.html { render :action=> "new" }
      end
     else 
     	format.html { redirect_to my_school_albums_path, notice: 'xxxx' }
     end
    end

   end
end
