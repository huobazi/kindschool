#encoding:utf-8
class Weixin::GardenGrowthRecordsController < Weixin::ManageController
  before_filter :student_at_garden?, :only => [:new, :update, :destroy, :create, :edit]
  def index
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = @kind.growth_records.where(:tp => 0, :student_info_id => current_user.student_info.id).page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @growth_records = @kind.growth_records.where(:tp => 0).page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end

  def new
    @growth_record = GrowthRecord.new
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 0

    if (@grades = @kind.grades) && !@grades.blank?
      if (@squads = @grades.first.squads) && !@squads.blank?
        @student_infos = @squads.first.student_infos
      end
    end
  end

  def update
    if params[:growth_record]
      params[:growth_record][:kindergarten_id] = @kind.id
      params[:growth_record][:creater_id] = current_user.id
      params[:growth_record][:tp] = 0
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

  def edit
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @growth_record = @kind.growth_records.find_by_id_and_tp_and_student_info_id(params[:id], 0, current_user.student_info.id)
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

