#encoding:utf-8
#相册锦集
class MySchool::AlbumsController  < MySchool::ManageController
   def index
     @albums = @kind.albums
   end

   def new
     @album = @kind.albums.new
     if @grades = @kind.grades
        if @squads = @grades.first.squads
          @student_infos = @squads.first.student_infos 
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

   def show
      @album = Album.find(params[:id])
      @album.album_entries 
      @album_entry=AlbumEntry.new()
   end

end
