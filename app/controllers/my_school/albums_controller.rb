#encoding:utf-8
#相册锦集
class MySchool::AlbumsController  < MySchool::ManageController
   def index

     if current_user.get_users_ranges[:tp] == :student
       if session[:operates].include?('my_school/albums/new')
          @albums = @kind.albums.where("creater_id = ? or squad_id = ? or squad_id is null", current_user.id, current_user.student_info.squad_id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
        else
          @albums = @kind.albums.where("is_show = 1 and (creater_id = ? or squad_id = ? or squad_id is null)",current_user.id, current_user.student_info.squad_id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
       end
     elsif current_user.get_users_ranges[:tp] == :teachers
       if session[:operates].include?('my_school/albums/new')
          @albums = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
        else
          @albums = @kind.albums.where("is_show = 1 and ( squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL )", current_user.staff.id, current_user.id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
       end
     else
       if session[:operates].include?('my_school/albums/new')
          @albums = @kind.albums.page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
       else
          @albums = @kind.albums.where(is_show: 1).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
       end
     end
   end

   def new
    @album = @kind.albums.new
    if current_user.get_users_ranges[:tp] == :student
      @album.squad_id = current_user.student_info.squad_id
    end
     if @grades = @kind.grades
     #    if @squads = @grades.first.squads
     #    end
     end
   end

   def create
    @album = @kind.albums.new(params[:album])
    if current_user.get_users.ranges == :student
      binding.pry
      if squad = Squad.find(params[:class_number].to_i)#where(:id=>params[:class_number].to_i).first
        @album.squad_id =  current_user.student_info.squad_id
        @album.squad_name = current_user.student_info.squad.name
      end
    end
    unless params[:class_number].blank?
      if squad = Squad.find(params[:class_number].to_i)#where(:id=>params[:class_number].to_i).first
         @album.squad =  squad
         @album.squad_name = squad.name
      end
    end
    @album.send_date = Time.now
     respond_to do |format|
      if @album.save
        format.html { redirect_to my_school_albums_path, :notice=> '相册锦集创建成功.' }
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
      if @squad = @album.squad
          @grade = @squad.grade
      else
          @squads  = []
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
        format.html { redirect_to my_school_albums_path, notice: '相册锦集修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end

   end

   def show
      @album = @kind.albums.find(params[:id])
      @album_entries=@album.album_entries.page(params[:page] || 1).per(6).order("created_at DESC") 
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
