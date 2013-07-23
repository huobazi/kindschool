#encoding:utf-8
#相册锦集
class Weixin::AlbumsController  < Weixin::ManageController
  def index
    @albums = @kind.albums.where(:is_show=>1).page(params[:page] || 1).per(6).order("created_at DESC")
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
