#encoding:utf-8
class Weixin::GardenGrowthRecordsController < Weixin::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).page(params[:page] || 1).per(10).order("created_at DESC")
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @growth_records = @kind.growth_records.where(:tp => 0).page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end

  def new
    if current_user.get_users_ranges[:tp] == :student
      flash[:notice] = "权限不够"
      redirect_to :action => :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_squads
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

  end

  def update
    if params[:growth_record]
      params[:growth_record][:kindergarten_id] = @kind.id
      params[:growth_record][:creater_id] = current_user.id
      params[:growth_record][:tp] = 0
    end
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
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

      if @growth_record.save!
        flash[:success] = "创建宝宝在园成长记录成功"
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
      @growth_records = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)")
      @growth_record = GrowthRecord.find_by_id_and_tp(params[:id], 0)
      unless @growth_record.nil?
        unless @growth_records.include?(@growth_record)
          flash[:error] = "没有权限或该宝宝在园成长记录不存在"
          redirect_to :action => :index
          return
        end
      else
        flash[:error] = "没有权限或该宝宝在园成长记录不存在"
        redirect_to :action => :index
        return
      end
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :index
    end
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.where("tp = ? and student_info_id = ?", 0, current_user.student_info.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @growth_records = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and tp=0",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)")
      @growth_record = GrowthRecord.find_by_id_and_tp(params[:id], 0)
      unless @growth_record.nil?
        unless @growth_records.include?(@growth_record)
          flash[:error] = "没有权限或该宝宝在园成长记录不存在"
          redirect_to :action => :index
          return
        end
      else
        flash[:error] = "没有权限或该宝宝在园成长记录不存在"
        redirect_to :action => :index
        return
      end
    else
      @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 0)
    end
    if @growth_record.nil?
      flash[:error] = "没有权限或该宝宝在园成长记录不存在"
      redirect_to :action => :index
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
         @student_infos = squad.student_infos
      end
    end
    render "squad_student", :layout => false
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

end

