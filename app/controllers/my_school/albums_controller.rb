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
     respond_to do |format|
      if @albums.save
        format.html { redirect_to my_school_albums_path, notice: '学员的育苗 was successfully created.' }
      else
        format.html { render :action=> "new" }
      end
    end
   end


end
