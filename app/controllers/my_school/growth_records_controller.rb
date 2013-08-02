#encoding:utf-8
class  MySchool::GrowthRecordsController < MySchool::ManageController

  def home
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).page(params[:page] || 1).per(10).order("created_at DESC")
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=1",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @growth_records = @kind.growth_records.search(params[:growth_record] || {}).where(:tp => 1).page(params[:page] || 1).per(10).order("created_at DESC")
    end
    render :index
  end

  def new
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :action => :home
    end
    @growth_record = GrowthRecord.new
    if current_user.get_users_ranges[:tp] == :student
      @growth_record.student_info_id = current_user.student_info.id
    end
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 1

    @grades = @kind.grades.order("sequence ASC")
  end

  def create
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :controller => "/my_school/growth_records", :action => :home
    end
    @growth_record = GrowthRecord.new(params[:growth_record])
    if current_user.get_users_ranges[:tp] == :student
      @growth_record.student_info_id = current_user.student_info.id
    end
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 1

    if @growth_record.save!
      flash[:success] = "添加宝宝在家成长记录成功"
      redirect_to :action => :show, :id => @growth_record.id
    else
      flash[:error] = "添加宝宝在家成长记录失败"
      render :new
    end
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=1",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在家成长记录不存在"
      redirect_to :action => :home
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :controller => "/my_school/growth_records", :action => :home
    end
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在家成长记录不存在"
      redirect_to :action => :home
    end
  end
  def update
    if current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :controller => "/my_school/growth_records", :action => :home
    end
    if params[:growth_record]
      params[:growth_record][:kindergarten_id] = @kind.id
      params[:growth_record][:tp] = 1
      if current_user.get_users_ranges[:tp] == :student
        params[:growth_record][:student_info_id] = current_user.student_info.id
      end
    end
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).find_by_id(params[:id])
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.update_attributes(params[:growth_record])
      flash[:success] = "修改宝宝在家成长记录成功"
      redirect_to :action => :show, :id => @growth_record.id
    else
      flash[:error] = "修改宝宝在家成长记录失败"
      render :edit
    end
  end

  def destroy
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and (creater_id = ? or student_info_id = ?)", 1, current_user.id, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      flash[:notice] = "没有权限或非法操作"
      redirect_to :controller => "/my_school/growth_records", :action => :home
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在家成长记录不存在"
      redirect_to :action => :home
    end
    @growth_record.destroy

    respond_to do |format|
      flash[:success] = "删除宝宝在家成长记录成功"
      format.html { redirect_to(:action => :index) }
      format.xml { head :ok }
    end
  end

  def destroy_multiple
    if params[:growth].nil?
      flash[:notice] = "必须选择宝宝在家成长记录"
    else
      GrowthRecord.destroy(params[:growth])
    end
    respond_to do |format|
      format.html { redirect_to home_my_school_growth_records_path }
      format.json { head :no_content }
    end
  end

  def grade_squad_partial
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_squad", :layout => false
  end

  def squad_student_partial
    if grade=@kind.grades.where(:id=>params[:grade].to_i).first
      if squad = grade.squads.where(:id=>params[:squad].to_i).first
         @student_infos = squad.student_infos
      end
    elsif squad = Squad.where(:id => params[:squad].to_i).first
      @student_infos = squad.student_infos
    end
    render "squad_student", :layout => false
  end

end
