#encoding:utf-8
class  MySchool::StudentInfosController < MySchool::ManageController

  def index
    @student_infos = @kind.student_infos.page(params[:page] || 1).per(10)
  end

  def show
    @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def new
    @student_info = StudentInfo.new
    @student_info.kindergarten = @kind
    @student_info.user = User.new(:kindergarten_id => @kind.id, :tp => 1)
  end

  def create
    @student_info = StudentInfo.new(params[:student_info])
    if @student_info.save!
      redirect_to my_school_student_info_path(@student_info), :notice => "添加学员成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_student_infos_path
    end
  end

  def edit
    if current_user.student_info.id != params[:id].to_i
      flash[:notice] = "不能编辑他人的信息"
      redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
    else
      current_user
      @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    end
  end

  def update
    @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    respond_to do |format|
      if @student_info.update_attributes(params[:student_info])
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@student_info.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @student_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    @student_info.destroy

    respond_to do |format|
      flash[:notice] = '删除学员成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end

end
