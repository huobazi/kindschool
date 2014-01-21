#encoding:utf-8
#相册锦集
require 'mime/types'
class MySchool::AlbumsController  < MySchool::ManageController
  #  protect_from_forgery :except=>:add_entry_imgs

  def index
    if current_user.get_users_ranges[:tp] == :student
      @squad = current_user.student_info.squad #.collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      if (session[:operates] || []).include?('my_school/albums/new')
        @albums = @kind.albums.search(params[:album] || {}).where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).page(params[:page] || 1)
      else
        @albums = @kind.albums.search(params[:album] || {}).where("is_show = 1 and (squad_id = ? or squad_id is null)", current_user.student_info.squad_id).page(params[:page] || 1)
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
        @all_squads = current_user.staff.squads.where(:graduate=>false).collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      if (session[:operates] || []).include?('my_school/albums/new')
        @albums = @kind.albums.search(params[:album] || {}).where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1)
      else
        @albums = @kind.albums.search(params[:album] || {}).where("is_show = 1 and ( squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL )", current_user.staff.id, current_user.id).page(params[:page] || 1)
      end
    else
        @all_squads = @kind.squads.where(:graduate=>false).collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      if (session[:operates] || []).include?('my_school/albums/new')
        @albums = @kind.albums.search(params[:album] || {}).page(params[:page] || 1)
      else
        @albums = @kind.albums.search(params[:album] || {}).where(:is_show=> 1).page(params[:page] || 1)
      end
    end

    store_search_location
  end

  def new
    @album = @kind.albums.new
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to :action=> :index
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
      redirect_to :action=> :index
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
           squad = Squad.find(params[:album][:squad_id].to_i)
           params[:album][:squad_name] = squad.name
        end
      else
        if (session[:operates] || []).include?('my_school/albums/new')
           params[:album].delete :squad_id
        else
           flash[:error] = "非法操作"
           redirect_to :action => :index
           return
        end
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
    @album.creater_id = current_user.id
    respond_to do |format|
      if @album.save
        format.html { redirect_to my_school_albums_path, :notice=> '相册锦集创建成功.' }
      else
        format.html { render :action=> "new" }
      end
    end
  end

  #增加相册的图片
  def add_entry_imgs
    if @album = @kind.albums.find(params[:id])
      if current_user.get_users_ranges[:tp] == :student
        render :text=>"没有权限"
        return
      end
      @album_entry = @album.album_entries.new(params[:album_entry])
      if params[:Filedata].blank?
        render :text=>"没有上传文件."
      else
      asset_img = AssetImg.new
       asset_img.swf_uploaded_data= params[:Filedata]
        @album_entry.asset_img = asset_img
        if @album_entry.save!
          @album_entry.asset_img_id = @album_entry.asset_img.id
          @album_entry.save
          render :json => { :result => 'success', :asset => @album_entry.id }
        else
          render :json => { :result => 'error', :error => @album_entry.errors.full_messages.to_sentence }
        end
      end
    end
  end

  def grade_class
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      if params[:graduate].present? and params[:graduate] == "true"
        @squads = grade.squads
      else
        @squads = grade.squads.where(:graduate => false)
      end

      if params[:squad_id].present?
        @squad_id = params[:squad_id]
      end
    end
    render "grade_class", :layout => false
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
    # if @grades = @kind.grades
    #   if @squads = @grades.first.squads
    #   end
    # end
    # if @squad = @album.squad
    #   @grade = @squad.grade
    # else
    #   @squads  = []
    # end
    if @grades = @kind.grades
      if current_user.get_users_ranges[:tp] == :all
        if @squads = @grades.first.squads.where(:graduate => false)
        end
      elsif current_user.get_users_ranges[:tp] == :teachers
        if @album.squad
          @squads = current_user.get_users_ranges[:squads]
        else
          flash[:error] = "没有权限"
          redirect_to :action => :index
        end
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
        format.html { redirect_to my_school_albums_path, :notice=> '相册锦集修改成功.' }
      else
        format.html { render :action=> :edit }
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
      redirect_to :action=> :index
      return
    else
      if current_user.id == @album.creater_id
        @album.accessed_at = Time.now.utc
        @album.save
      end
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
      redirect_to :action=>index
      return
    end
    @album_entries=@album.album_entries.page(params[:page] || 1).per(6).order("created_at DESC")
    @album_entry=AlbumEntry.new()
  end

  def destroy
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
    @album.destroy
    respond_to do |format|
      format.html { redirect_to my_school_albums_path }
      format.json { head :no_content }
    end
  end

  def graduate_class
    if current_user.get_users_ranges[:tp] == :teachers
      if params[:graduate]=="true"
        @all_squads = current_user.staff.squads.collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      else
        @all_squads = current_user.staff.squads.where(:graduate => false).collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      end
    else
      if params[:graduate] == "true"
        @all_squads = @kind.squads.collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      else
        @all_squads = @kind.squads.where(:graduate => false).collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
      end
    end
    render "graduate_class", :layout => false
  end

  private
  def fixture_file_upload(path, mime_type = nil, binary = false)
    fixture_path = self.class.fixture_path if self.class.respond_to?(:fixture_path)
    Rack::Test::UploadedFile.new("#{fixture_path}#{path}", mime_type, binary)
  end

end
