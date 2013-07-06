#encoding:utf-8
class  MySchool::StaffsController < MySchool::ManageController
  def index
    @staffs = @kind.staffs.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @staff = Staff.find_by_id(params[:id])
  end

  def new
    @staff = Staff.new
    @staff.user = User.new(:kindergarten_id => @kind.id, :tp => 1)
  end

  def create
    @staff = Staff.new(params[:staff])
    if @staff.save!
      redirect_to my_school_staff_path(@staff), :notice => "操作成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_staffs_path
    end
  end

  def edit
    @staff = Staff.find_by_id(params[:id])
  end

  def destroy
    @staff = Staff.find_by_id(params[:id])
    @staff.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end

  def update
    @staff = Staff.find_by_id(params[:id])
    respond_to do |format|
      if @staff.update_attributes(params[:staff])
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@staff.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @staff.errors, :status => :unprocessable_entity }
      end
    end
  end

end
