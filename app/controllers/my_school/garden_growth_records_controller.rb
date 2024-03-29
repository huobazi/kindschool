#encoding:utf-8
# require 'action_controller'
# require 'action_controller/test_process.rb'
require 'action_dispatch/testing/test_process'
class  MySchool::GardenGrowthRecordsController < MySchool::ManageController

  def garden
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).page(params[:page] || 1)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).joins("INNER JOIN student_infos as s on(s.id = growth_records.student_info_id)").where("growth_records.tp = 0 and ( s.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) or creater_id = ? )",current_user.staff.id, current_user.id).page(params[:page] || 1)
      @all_squads = current_user.staff.squads.where(:graduate=>false).collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
    else
      @growth_records = @kind.growth_records.search(params[:growth_record] || {}).where(:tp => 0).page(params[:page] || 1)
      @all_squads = @kind.squads.where(:graduate=>false).collect{|x|["#{x.name}   #{x.historyreview}",x.id]}
    end
    store_search_location
    if request.xhr?
      @search_record = "growth_records"
      @search_record_count = @growth_records.total_count
      render "my_school/commons/_search_index.js.erb"
    else
      render "my_school/growth_records/index"
    end
  end

  def delete_img
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("tp = 0 and ( student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) or creater_id = ? )",current_user.staff.id, current_user.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :garden
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
      redirect_to :action => :garden
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
      if @squads.empty?
        flash[:error] = "该教职工没有负责的班级"
        redirect_to :action => :garden
        return
      end
    else
      @grades = @kind.grades
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
     render "my_school/growth_records/new"
  end

  def create
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "没有权限"
      redirect_to :controller => "/my_school/growth_records", :action => :garden
    else
      @growth_record = GrowthRecord.new(params[:growth_record])
      if (@squad = @kind.squads.find_by_id(params[:squad])) && @squad.name.present?
        @growth_record.squad_name = @squad.name
      else
        flash[:error] = "非法操作"
        redirect_to :action => :index
        return
      end
      @growth_record.creater_id = current_user.id
      @growth_record.kindergarten_id = @kind.id
      @growth_record.tp = 0
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
      if @growth_record.save!
       credit = current_user.save_user_credit("growth_record",2,@growth_record.student_info.user)
      unless credit.blank?
        session[:add_credit] = credit
      end
        flash[:success] = "添加宝宝在园成长记录成功"
        redirect_to :controller => "/my_school/garden_growth_records", :action => :show, :id => @growth_record.id
      else
        flash[:error] = "添加宝宝在园成长记录失败"
        render "my_school/growth_records/new"
      end
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
      @growth_record = GrowthRecord.where("tp = 0 and ( student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) or creater_id = ? )",current_user.staff.id, current_user.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").readonly(false).find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :garden
      return
    else
      render "my_school/growth_records/show"
      if current_user.id == @growth_record.creater_id
        @growth_record.accessed_at = Time.now.utc
        @growth_record.save
      end
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "没有权限或非法操作"
      redirect_to :action => :garden
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("tp = 0 and ( student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) or creater_id = ? )",current_user.staff.id, current_user.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :garden
    else
      render "my_school/growth_records/edit"
    end
  end

  def update
    if params[:growth_record]
      params[:growth_record][:tp] = 0
      params[:growth_record][:kindergarten_id] = @kind.id
    end
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    respond_to do |format|
      unless params[:asset_imgs].blank?
        params[:asset_imgs].each do |k,v|
          @growth_record.asset_imgs << AssetImg.new(:uploaded_data=>v)
        end
        @growth_record.save
      end
      if @growth_record.update_attributes(params[:growth_record])
        flash[:success] = '更新宝宝在园成长记录成功.'
        format.html { redirect_to(:action=>:show,:id=>@growth_record.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @growth_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    unless params[:growth_record].blank? 
      @growth_records = @kind.growth_records.where(:id=>params[:growth_record])
    else
      @growth_records = @kind.growth_records.where(:id=>params[:id])
    end
    if @growth_records.blank?
      flash[:error] = "请选择成长记录"
      redirect_to :action => :index
      return
    end
    @growth_records.each do |growth_record|
      growth_record.destroy
    end
    respond_to do |format|
      flash[:success] = "删除成长记录成功"
      format.html { redirect_to garden_my_school_garden_growth_records_path }
      format.json { head :no_content }
    end
  end

  private
   def fixture_file_upload(path, mime_type = nil, binary = false)
      fixture_path = self.class.fixture_path if self.class.respond_to?(:fixture_path)
      Rack::Test::UploadedFile.new("#{fixture_path}#{path}", mime_type, binary)
   end

end
