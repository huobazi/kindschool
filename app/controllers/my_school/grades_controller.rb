#encoding:utf-8
class  MySchool::GradesController < MySchool::ManageController

  def index
    @grades = @kind.grades.search(params[:grade] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
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
    unless params[:grade].blank? 
      @grades = @kind.grades.where(:id=>params[:grade])
    else
      @grades = @kind.grades.where(:id=>params[:id])
    end
    if @grades.blank?
      flash[:error] = "请选择年级"
      redirect_to :action => :index
      return
    end
    @grades.each do |grade|
      grade.destroy
    end
    respond_to do |format|
      flash[:success] = "删除年级成功"
      format.html { redirect_to my_school_grades_path }
      format.json { head :no_content }
    end
  end

  def update
    params[:grade][:kindergarten_id] = @kind.id if params[:grade]
    @grade = Grade.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        flash[:notice] = '修改年级信息成功.'
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
      redirect_to my_school_grade_path(@grade), :success => "操作成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_grades_path
    end
  end

  def destroy_multiple
    if params[:grade].nil?
      flash[:notice] = "必须选择年级"
    else
      params[:grade].each do |grade|
        @kind.grades.destroy(grade)
      end
    end
    respond_to do |format|
      format.html { redirect_to my_school_grades_path }
      format.json { head :no_content }
    end
  end

end
