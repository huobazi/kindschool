#encoding:utf-8
#相册锦集
class MySchool::AlbumsController  < MySchool::ManageController
  def index

    if current_user.get_users_ranges[:tp] == :student
      if (session[:operates] || []).include?('my_school/albums/new')
        @albums = @kind.albums.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
      else
        @albums = @kind.albums.where("is_show = 1 and (squad_id = ? or squad_id is null)", current_user.student_info.squad_id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      if (session[:operates] || []).include?('my_school/albums/new')
        @albums = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
      else
        @albums = @kind.albums.where("is_show = 1 and ( squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL )", current_user.staff.id, current_user.id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
      end
    else
      if (session[:operates] || []).include?('my_school/albums/new')
        @albums = @kind.albums.page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
      else
        @albums = @kind.albums.where(is_show: 1).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
      end
    end
  end

  def new
    @album = @kind.albums.new
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
    else current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
    end
    if @grades = @kind.grades
      #    if @squads = @grades.first.squads
      #    end
    end
  end

  def create
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
    end
    if params[:album].present? && params[:album][:squad_id].present?
      if params[:album][:squad_id].to_i > 0
        if current_user.get_users_ranges[:tp] == :teachers
          unless current_user.get_users_ranges[:squads].collect(&:id).include?(params[:album][:squad_id].to_i)
            flash[:error] = "非法操作"
            redirect_to :action => :index
            return
          end
        end
      else
        params[:album].delete :squad_id
      end
    end
    @album = @kind.albums.new(params[:album])
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
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find(params[:id])
    end
    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to action: "index"
      return
    end
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

    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find(params[:id])
    end

    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to action: "index"
      return
    end
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
    if current_user.get_users_ranges[:tp] == :student
      @album = @kind.albums.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find_by_id(params[:id])
    end
    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to action: "index"
      return
    end
    @album_entries=@album.album_entries.order("created_at DESC")
    @album_entry=AlbumEntry.new()
  end
  def entry_index
    if current_user.get_users_ranges[:tp] == :student
      @album = @kind.albums.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find_by_id(params[:id])
    end
    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to action: "index"
      return
    end
    @album_entries=@album.album_entries.page(params[:page] || 1).per(6).order("created_at DESC")
    @album_entry=AlbumEntry.new()
  end

  def destroy
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find(params[:id])
    end
    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to action: "index"
      return
    end
    @album.destroy
    respond_to do |format|
      format.html { redirect_to my_school_albums_path }
      format.json { head :no_content }
    end
  end

end
