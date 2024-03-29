#encoding:utf-8
class Weixin::GardenGrowthRecordsController < Weixin::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).page(params[:page] || 1)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").page(params[:page] || 1)
    else
      @growth_records = @kind.growth_records.where(:tp => 0).page(params[:page] || 1)
    end
    AccessStatu.update_unread(@kind, "GrowthRecord", current_user)
  end

  def delete_img
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :index
    else
      if params[:img_id]
        if img = @growth_record.asset_imgs.find_by_id(params[:img_id])
          if img.destroy
            flash[:notice] = "图片删除成功。"
          else
            flash[:error] = "图片删除失败。"
          end
        else
          flash[:error] = "图片不存在。"
        end
      end
      redirect_to :action=>:show,:id=>@growth_record.id
    end
  end

  def new
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "权限不够"
      redirect_to :action => :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
      if @squads.empty?
        flash[:error] = "该教职工还没有负责的班级"
        redirect_to :action => :index
      end
    else
      if (@grades = @kind.grades) && !@grades.blank?
        if (@squads = @grades.first.squads) && !@squads.blank?
          @student_infos = @squads.first.student_infos
        end
      end
    end
    @growth_record = GrowthRecord.new
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 0
    @growth_record.start_at = Time.now.beginning_of_week.to_short_datetime
    @growth_record.end_at = Time.now.end_of_week.to_short_datetime
    unless params[:personal_set_id].blank?
      @set = current_user.personal_sets.find_by_id(params[:personal_set_id])
      if  !@set.blank? && @set.resource
        if @set.resource_type == "PhotoGallery"
          @growth_record.asset_imgs << AssetImg.new(:uploaded_data=>@set.resource.uploaded_data)
          @set_imge = @set.resource.public_filename
        elsif @set.resource_type=="TextSet"
          @growth_record.content = @set.resource.content
          @growth_record.audio_turn = @set.resource.audio_turn if @set.resource.tp == 1 && !@set.resource.audio_turn.blank?
        end
      end
    end
  end

  def update
    if params[:growth_record]
      params[:growth_record][:kindergarten_id] = @kind.id
      params[:growth_record][:tp] = 0
    end
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    unless params[:asset_imgs].blank?
      params[:asset_imgs].each do |k,v|
        @growth_record.asset_imgs << AssetImg.new(:uploaded_data=>v)
      end
      @growth_record.save
    end
    if @growth_record.update_attributes(params[:growth_record])
      flash[:success] = "修改宝宝在园成长记录成功"
      redirect_to weixin_garden_growth_record_path(@growth_record)
    else
      flash[:error] = "修改宝宝在园成长记录失败"
      render :edit
    end
  end

  def create
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "没有权限"
      redirect_to :controller => "/my_school/growth_records", :action => :garden
    else
      @growth_record = GrowthRecord.new(params[:growth_record])
      @growth_record.kindergarten_id = @kind.id
      @growth_record.creater_id = current_user.id
      @growth_record.tp = 0
      if student = @kind.student_infos.find_by_id(params[:growth_record][:student_info_id])
        @growth_record.squad_name = student.squad.try(:name)
      else
        flash[:error] = "操作失败"
        redirect_to :action => :index
      end
      unless params[:personal_set_id].blank?
        set = current_user.personal_sets.find_by_id(params[:personal_set_id])
        if  !set.blank? && set.resource
          if set.resource_type == "PhotoGallery"
            asset_img = AssetImg.new()
            file_url =  "#{Rails.root}/public#{set.resource.public_filename}"
            uploaded_data =  fixture_file_upload file_url, 'image/png' # (file_url, 'image/jpeg', false)
            asset_img = AssetImg.new(:uploaded_data=>uploaded_data)
            @growth_record.asset_imgs  << asset_img
          elsif set.resource_type == "TextSet"
            @growth_record.audio_turn = set.resource.audio_turn if set.resource.tp == 1 && !set.resource.audio_turn.blank?
          end
        end
      end
      unless params[:asset_imgs].blank?
        params[:asset_imgs].each do |k,v|
          @growth_record.asset_imgs << AssetImg.new(:uploaded_data=>v)
        end
      end
      if @growth_record.save
        credit = current_user.save_user_credit("growth_record",2,@growth_record.student_info.user)
        unless credit.blank?
          session[:add_credit] = credit
       end
        flash[:success] = "创建宝宝在园成长记录成功"
        current_user.save_user_credit("growth_record",2,@growth_record.student_info.user)
        redirect_to :action => :show, :id => @growth_record.id
      else
        flash[:error] = "创建宝宝在园成长记录失败"
        render :new
      end
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "没有权限或非法操作"
      redirect_to :action => :index
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("tp = 0 and ( student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) or creater_id = ? )",current_user.staff.id, current_user.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :index
    end
  end

  def show
    unless session[:add_credit].blank?
      @add_credit = session[:add_credit]
      session[:add_credit]=nil
    end
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").readonly(false).find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :index
      return
    else
      if current_user.id == @growth_record.creater_id
        @growth_record.accessed_at = Time.now.utc
        @growth_record.save
      end
    end
  end

  def destroy
    @growth_record = @kind.growth_records.find_by_id(params[:id])
    @growth_record.destroy

    respond_to do |format|
      flash[:success] = "删除宝宝在园成长记录成功"
      format.html { redirect_to(:action => :index) }
      format.xml { head :ok }
    end
  end

  protected
  def student_at_garden?
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "权限不够"
      redirect_to :action => :index
    end
  end
  private
  def fixture_file_upload(path, mime_type = nil, binary = false)
    fixture_path = self.class.fixture_path if self.class.respond_to?(:fixture_path)
    Rack::Test::UploadedFile.new("#{fixture_path}#{path}", mime_type, binary)
  end
end

