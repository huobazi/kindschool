#encoding:utf-8
#相册
class MySchool::AlbumEntriesController < MySchool::ManageController
   def create
   	 @album = @kind.albums.find(params[:album_id])
   	 @album_entry = @album.album_entries.new(params[:album_entry]) 
   	   flag = false
   	 unless params[:uploaded_data].blank?
        @album_entry.asset_img = AssetImg.new(:uploaded_data=>params[:uploaded_data])
        flag = true
     end
     respond_to do |format|
     if flag
      if @album_entry.save && @album_entry.asset_img.save
        @album_entry.asset_img_id = @album_entry.asset_img.id
        @album_entry.save
        format.html { redirect_to  my_school_album_path(@album), notice: '图片上传 was successfully created.' }
      else
        format.html { render :action=> "new" }
      end
     else 
     	format.html { redirect_to  my_school_album_path(@album), notice: '没有上传文件' }
     end
    end

   end

   def new
      @album = @kind.albums.find(params[:album_id])
      @album_entry=AlbumEntry.new()
   end
   
   def update
    @album = @kind.albums.find(params[:album_id])
   	@album_entry = @album.album_entries.find(params[:id])
   	respond_to do |format|
      if @album_entry.update_attributes(params[:album_entry])
        format.html { redirect_to my_school_album_path(@album), notice: '照片标题 was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

   def destroy
   	 @album = @kind.albums.find(params[:album_id])
   	 @album_entry = @album.album_entries.find(params[:id])
     @album_entry.destroy
      respond_to do |format|
      format.html { redirect_to my_school_album_path(@album) }
      format.json { head :no_content }
    end
  end

  def choose_main_img
    @album = @kind.albums.find(params[:album_id])
    @album_entry = @album.album_entries.find(params[:id])
    @album.album_entry_id =@album_entry.id
     if @album.save
         redirect_to  my_school_album_path(@album), notice: '图片上传 was successfully created.' 
      else
         render :action=> "new" 
      end
  end

end
