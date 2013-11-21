#encoding:utf-8
#相册锦集
class Weixin::AlbumsController  < Weixin::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @albums = @kind.albums.where("is_show = 1 and (squad_id = ? or squad_id is null)", current_user.student_info.squad_id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
    elsif current_user.get_users_ranges[:tp] == :teachers
      @albums = @kind.albums.where("is_show = 1 and ( squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL )", current_user.staff.id, current_user.id).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
    else
      @albums = @kind.albums.where(:is_show=> 1).page(params[:page] || 1).per(6).order("is_top DESC, created_at DESC")
    end
    AccessStatu.update_unread(@kind, "Album", current_user)
  end

  def grade_class
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_class", :layout => false
  end

  def show
    @album = @kind.albums.find(params[:id])
    @album_entries=@album.album_entries.page(params[:page] || 1).per(6).order("created_at DESC")
    unless @album.nil?
      if current_user.id == @album.creater_id
        @album.accessed_at = Time.now.utc
        @album.save
      end
    end
  end
  
  def edit
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to :action=> :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find(params[:id])
    end
    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to :action=> "index"
      return
    end
    
    if @grades = @kind.grades
      if current_user.get_users_ranges[:tp] == :all
        if @squads = @grades.first.squads.where(:graduate => false)
        end
      elsif current_user.get_users_ranges[:tp] == :teachers
        @squads = current_user.get_users_ranges[:squads]
      end
    end
    if @squad = @album.squad
      @grade = @squad.grade
    else
      if current_user.get_users_ranges[:tp] == :all
        @squads  = []
      end
    end
  end


  def update
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to :action=> :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @album = @kind.albums.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @album = @kind.albums.find(params[:id])
    end

    if @album.nil?
      flash[:error] = "没有权限或相册不存在"
      redirect_to :action=> :index
      return
    end
    unless params[:class_number].blank?
      if squad = Squad.find(params[:class_number].to_i)#where(:id=>params[:class_number].to_i).first
        @album.squad =  squad
        @album.squad_name = squad.name
      end
    else
      if params[:grade] == "0"
        @album.squad =  nil
        @album.squad_name = nil
      end
    end
    @album.save
    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to weixin_albums_path, :notice=> '相册锦集修改成功.' }
      else
        format.html { render :action=> :edit }
      end
    end

  end
end
