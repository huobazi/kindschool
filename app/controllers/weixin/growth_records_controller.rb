#encoding:utf-8
class Weixin::GrowthRecordsController < Weixin::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).page(params[:page] || 1)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=1",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").page(params[:page] || 1)
    else
      @growth_records = @kind.growth_records.where(:tp => 1).page(params[:page] || 1)
    end
    AccessStatu.update_unread(@kind, "GrowthRecord", current_user)
  end

  def delete_img
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.find_by_id_and_tp_and_creater_id(params[:id], 1, current_user.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=1",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在家成长记录不存在"
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
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:error] = "没有权限或非法操作"
      redirect_to :action => :index
    end
    @growth_record = GrowthRecord.new
    if current_user.get_users_ranges[:tp] == :student
      @growth_record.student_info_id = current_user.student_info.id
    end
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 1
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
    if (@grades = @kind.grades) && !@grades.blank?
      if (@squads = @grades.first.squads) && !@squads.blank?
        @student_infos = @squads.first.student_infos
      end
    end
  end

  def update
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :action => :index
    end
    if params[:growth_record]
      params[:growth_record][:kindergarten_id] = @kind.id
      params[:growth_record][:tp] = 1
      if current_user.get_users_ranges[:tp] == :student
        params[:growth_record][:student_info_id] = current_user.student_info.id
      end
    end
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.find_by_id_and_tp_and_creater_id(params[:id], 1, current_user.id)
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    unless params[:asset_imgs].blank?
      params[:asset_imgs].each do |k,v|
        @growth_record.asset_imgs << AssetImg.new(:uploaded_data=>v)
      end
      @growth_record.save
    end
    if @growth_record.update_attributes(params[:growth_record])
      flash[:success] = "修改宝宝在家成长记录成功"
      redirect_to :action => :show, :id => @growth_record.id
    else
      flash[:error] = "修改宝宝在家成长记录失败"
      render :edit
    end
  end

  def create
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:error] = "没有权限或非法操作"
      redirect_to :action => :index
    end
    @growth_record = GrowthRecord.new(params[:growth_record])
    if current_user.get_users_ranges[:tp] == :student
      @growth_record.student_info_id = current_user.student_info.id
      @growth_record.squad_name = current_user.student_info.squad.name
    else
      if (@squad = @kind.squads.find_by_id(params[:squad])) && @squad.name.present?
        @growth_record.squad_name = @squad.name
      else
        flash[:error] = "非法操作"
        redirect_to :action => :index
        return
      end
    end
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 1
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
      #这个地方添加宝宝在家积分
     credit =  current_user.save_user_credit("growth_record",2,@growth_record.creater)
      unless credit.blank?
        session[:add_credit] = credit
      end
      flash[:success] = "创建宝宝在家成长记录成功"
      redirect_to :action => :show, :id => @growth_record.id
    else
      flash[:error] = "创建宝宝在家成长记录失败"
      render :new
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :action => :index
    end
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在家成长记录不存在"
      redirect_to :action => :index
    end
  end

  def show
    unless session[:add_credit].blank?
      @add_credit = session[:add_credit]
      session[:add_credit]=nil
    end
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.find_by_id_and_tp_and_creater_id(params[:id], 1, current_user.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=1",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在家成长记录不存在"
      redirect_to :action => :index
      return
    else
      if current_user.id == @growth_record.creater_id
        @growth_record.accessed_at = Time.now.utc
        @growth_record.save
      end
    end
  end

  def grade_squad
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_squad", :layout => false
  end

  def squad_student
    if grade=@kind.grades.where(:id=>params[:grade].to_i).first
      if squad = grade.squads.where(:id=>params[:squad].to_i).first
        if params[:unfinished].presence == "true"
          @unfinished = true
          @student_infos = squad.student_infos.select { |student| student.growth_records.week_stat(Time.now.beginning_of_week, Time.now.end_of_week).where(tp: 0).empty? }
        else
          @student_infos = squad.student_infos
        end
      end
    elsif squad = Squad.where(:id => params[:squad].to_i).first
      if params[:unfinished].presence == "true"
        @unfinished = true
        @student_infos = squad.student_infos.select { |student| student.growth_records.week_stat(Time.now.beginning_of_week, Time.now.end_of_week).where(tp: 0).empty? }
      else
        @student_infos = squad.student_infos
      end
    end
    render "squad_student", :layout => false
  end

  def destroy
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.find_by_id_and_tp_and_creater_id(params[:id], 1, current_user.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :controller => "/my_school/growth_records", :action => :home
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    @growth_record.destroy

    respond_to do |format|
      flash[:success] = "删除宝宝在家成长记录成功"
      format.html { redirect_to(:action => :index) }
      format.xml { head :ok }
    end
  end
  private
  def fixture_file_upload(path, mime_type = nil, binary = false)
    fixture_path = self.class.fixture_path if self.class.respond_to?(:fixture_path)
    Rack::Test::UploadedFile.new("#{fixture_path}#{path}", mime_type, binary)
  end
end

