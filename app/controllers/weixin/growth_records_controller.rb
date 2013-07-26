#encoding:utf-8
class Weixin::GrowthRecordsController < Weixin::ManageController
  def index
    @growth_records = @kind.growth_records.where(:tp => 1).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def new
    @growth_record = GrowthRecord.new
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 1

    if (@grades = @kind.grades) && !@grades.blank?
      if (@squads = @grades.first.squads) && !@squads.blank?
        @student_infos = @squads.first.student_infos 
      end
    end
  end

  def update
    if @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    else
      flash[:error] = "只能修改宝宝在家成长记录"
      redirect_to weixin_growth_records_path
    end

    if @growth_record.update_attributes(params[:growth_record])
      flash[:success] = "修改宝宝在家成长记录成功"
      redirect_to weixin_growth_record_path(@growth_record)
    else
      flash[:error] = "修改宝宝在家成长记录失败"
      render :edit
    end
  end

  def create
    params[:growth_record][:tp] = 1 if params[:growth_record]
    @growth_record = GrowthRecord.new(params[:growth_record])

    if @growth_record.save!
      flash[:success] = "创建宝宝在家成长记录成功"
      redirect_to weixin_growth_record_path(@growth_record)
    else
      flash[:error] = "创建宝宝在家成长记录失败"
      render :new
    end
  end

  def edit
    if @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    else
      flash[:error] = "只能编辑宝宝在家成长记录"
      redirect_to weixin_growth_records_path
    end
  end

  def show
    if @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    else
      flash[:error] = "只能查看宝宝在家成长记录"
      redirect_to weixin_growth_records_path
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
    if @growth_record = @kind.growth_records.find_by_id_and_tp(params[:id], 1)
    else
      flash[:error] = "只能删除宝宝在家成长记录"
      redirect_to weixin_growth_records_path
    end
    @growth_record.destroy

    respond_to do |format|
      flash[:success] = "删除宝宝在家成长记录成功"
      format.html { redirect_to(:action => :index) }
      format.xml { head :ok }
    end
  end
end

