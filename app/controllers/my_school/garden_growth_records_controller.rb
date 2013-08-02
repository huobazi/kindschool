#encoding:utf-8
class  MySchool::GardenGrowthRecordsController < MySchool::ManageController

  def garden
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).page(params[:page] || 1).per(10).order("created_at DESC")
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @growth_records = @kind.growth_records.search(params[:growth_record] || {}).where(:tp => 0).page(params[:page] || 1).per(10).order("created_at DESC")
    end
    render "my_school/growth_records/index"
  end

  def new
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "权限不够"
      redirect_to :action => :garden
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_squads
    else
      @grades = @kind.grades
    end
    @growth_record = GrowthRecord.new
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 0
    render "my_school/growth_records/new"
  end

  def create
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "没有权限"
      redirect_to :controller => "/my_school/growth_records", :action => :garden
    else
      @growth_record = GrowthRecord.new(params[:growth_record])
      @growth_record.creater_id = current_user.id
      @growth_record.kindergarten_id = @kind.id
      @growth_record.tp = 0

      if @growth_record.save!
        flash[:success] = "添加宝宝在园成长记录成功"
        redirect_to :controller => "/my_school/garden_growth_records", :action => :show, :id => @growth_record.id
      else
        flash[:error] = "添加宝宝在园成长记录失败"
        render "my_school/growth_records/new"
      end
    end
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :garden
    else
      render "my_school/growth_records/show"
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "没有权限或非法操作"
      redirect_to :action => :garden
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)")
      @growth_record = GrowthRecord.find_by_id_and_tp(params[:id], 0)
      unless @growth_record.nil?
        unless @growth_records.include?(@growth_record)
          flash[:error] = "没有权限或该宝宝在园成长记录不存在"
          redirect_to :action => :garden
          return
        end
      else
        flash[:error] = "没有权限或该宝宝在园成长记录不存在"
        redirect_to :action => :garden
        return
      end
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
      params[:growth_record][:creater_id] = current_user.id
      params[:growth_record][:tp] = 0
      params[:growth_record][:kindergarten_id] = @kind.id
    end
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    respond_to do |format|
      if @growth_record.update_attributes(params[:growth_record])
        flash[:notice] = '更新宝宝在园成长记录成功.'
        format.html { redirect_to(:action=>:show,:id=>@growth_record.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @growth_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy_multiple
    if params[:growth].nil?
      flash[:notice] = "必须选择宝宝在园成长记录"
    else
      GrowthRecord.destroy(params[:growth])
    end
    respond_to do |format|
      format.html { redirect_to garden_my_school_garden_growth_records_path }
      format.json { head :no_content }
    end
  end

end
