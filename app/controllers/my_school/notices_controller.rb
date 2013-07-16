#encoding:utf-8
class MySchool::NoticesController < MySchool::ManageController
  #列表界面
  def index
    @notices = @kind.notices.search(params[:notice] || {}).page(params[:page] || 1).per(10).order("send_date DESC")
  end

  def new
    @notice = Notice.new
  end
  def edit
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end
  def destroy
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @notice.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end
  def show
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def create
    @notice = Notice.new(params[:notice])
    @notice.kindergarten = @kind
    @notice.creater = current_user
    respond_to do |format|
      if @notice.save
        flash[:notice] = '提交通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@notice.id) }
        format.xml  { render :xml => @notice, :status => :created, :location => @notice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if @notice.update_attributes(params[:notice])
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@notice.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy_multiple
    if params[:notice].nil?
      flash[:notice] = "必须选择通知"
    else
      params[:notice].each do |notice|
        @kind.notices.destroy(notice)
      end
    end
    respond_to do |format|
      format.html { redirect_to my_school_notices_path }
      format.json { head :no_content }
    end
  end
end
