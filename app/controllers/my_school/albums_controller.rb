#encoding:utf-8
#相册锦集
class MySchool::AlbumsController  < MySchool::ManageController
   def index
     user = current_user
     arr = ['new','edit','destroy']
     controller_view='my_school/albums/new'
     if session[:operates].include?(controller_view)
        @albums = @kind.albums
      else  
        @albums = @kind.albums.where(:is_show=>1)
     end  
   end

   def new
     @album = @kind.albums.new
     if @grades = @kind.grades
        if @squads = @grades.first.squads
        end
     end
   end
   
   def create
    @album = @kind.albums.new(params[:album])
    unless params[:class_number].blank?
     if squad = Squad.find(params[:class_number].to_i)#where(:id=>params[:class_number].to_i).first
        @album.squad =  squad
        @album.squad_name = squad.name
      end 
    end
     respond_to do |format|
      if @album.save
        format.html { redirect_to my_school_albums_path, notice: '学员的育苗 was successfully created.' }
      else
        format.html { render :action=> "new" }
      end
    end
   end

   def grade_class
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
       @squads = grade.squads
    end
     render "grade_class", :layout => false
   end

   def edit
      @album = @kind.albums.find(params[:id])
      if @grades = @kind.grades
        if @squads = @grades.first.squads
        end
     end
   end

   def update
      @album = @kind.albums.find(params[:id])
      unless params[:class_number].blank?
       if squad = Squad.find(params[:class_number].to_i)#where(:id=>params[:class_number].to_i).first
        @album.squad =  squad
        @album.squad_name = squad.name
      end 
    end
     @album.save
    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to my_school_cook_books_path, notice: '学员菜谱 was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end

   end

   def show
      @album = @kind.albums.find(params[:id])
      @album.album_entries 
      @album_entry=AlbumEntry.new()
   end

  def destroy
     @album = @kind.albums.find(params[:id])
     @album.destroy
      respond_to do |format|
      format.html { redirect_to my_school_albums_path }
      format.json { head :no_content }
    end
  end

end
