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
  end
end
