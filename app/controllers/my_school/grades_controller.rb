#encoding:utf-8
class  MySchool::GradesController < MySchool::ManageController

  def index
    @grades = @kind.grades.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @grade = Grade.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def new
    @grade = Grade.new
    @grade.kindergarten_id = @kind.id
  end

  def edit
    @grade = Grade.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def destroy
    @grade = Grade.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @grade.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end

  def update
    @grade = Grade.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@grade.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create
    @grade = Grade.new(params[:grade])
    @grade.kindergarten_id = @kind.id
    if @grade.save!
      redirect_to my_school_grade_path(@grade), :notice => "操作成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_grades_path
    end
  end

end
