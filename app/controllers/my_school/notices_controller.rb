#encoding:utf-8
class MySchool::NoticesController < MySchool::ManageController
  #列表界面
  def index
    userrole = current_user.get_users_ranges
    unless userrole.blank?
      if  userrole[:tp] == :all
        send_range = [0,1,2]
        @notices = @kind.notices.where(:send_range=>send_range).search(params[:notice] || {}).page(params[:page] || 1).per(10).order("send_date DESC")
      elsif userrole[:tp] == :teachers
        # 如果是老师能够查看到所有的全教职工和全园的信息
        send_range = [0,1]
        @notices = @kind.notices.where("approve_status = 0 and send_date < ? or creater_id= ?" ,Time.zone.now,current_user.id).where(:send_range=>send_range).search(params[:notice] || {}).page(params[:page] || 1).per(10).order("send_date DESC")
      elsif userrole[:tp] == :student
        send_range = [0,2]
        @notices = @kind.notices.where("approve_status = 0 and send_date < ?" ,Time.zone.now).where(:send_range=>send_range).search(params[:notice] || {}).page(params[:page] || 1).per(10).order("send_date DESC")
      end
    end

    if request.xhr?
      @search_record = "notices"
      @search_record_count = @notices.total_count
      render "my_school/commons/_search_index.js.erb"
    else
      render "index"
    end

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
