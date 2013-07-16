#encoding:utf-8
class  MySchool::GardenGrowthRecordsController < MySchool::ManageController

  def garden
    if current_user.get_users_ranges[:tp] == :student
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where(:student_info_id => current_user.student_info.id).page(params[:page] || 1).per(10).order("created_at DESC")
    elsif current_user.get_users_ranges[:tp] == :teachers
      squads = current_user.get_users_ranges[:squads]
      @growth_records = GrowthRecord.search(params[:growth_record] || {}).where("student_infos.squad_id=? and tp=0",squads.collect(&:id)).joins("LEFT JOIN student_infos on(student_infos.id = growth_records.student_info_id)").page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @growth_records = @kind.growth_records.search(params[:growth_record] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
    end
    render "my_school/growth_records/index"
  end

  def new
    if current_user.get_users_ranges[:tp] == :student && params[:tp] == "0"
      flash[:notice] = "权限不够,请联系管理员"
      redirect_to :controller => "/my_school/garden_growth_records", :action => :garden
    else
      @growth_record = GrowthRecord.new
      @growth_record.kindergarten_id = @kind.id
      @growth_record.creater_id = current_user.id
      @growth_record.tp = params[:tp] unless params[:tp].nil?

      render "my_school/growth_records/new"
    end
  end

  def create
    if current_user.get_users_ranges[:tp] == :student && params[:growth_record][:tp] == "0"
      flash[:notice] = "没有权限,请联系管理员"
      redirect_to :controller => "/my_school/growth_records", :action => :home
    else
      @growth_record = GrowthRecord.new(params[:growth_record])
      @growth_record.creater_id = current_user.id

      if @growth_record.save!
        flash[:success] = "添加宝宝在园成长记录成功"
        redirect_to :controller => "/my_school/garden_growth_records", :action => :show, :id => @growth_record.id
      else
        flash[:error] = "添加宝宝在园成长记录失败"
        render "my_school/growth_records/new"
      end
    end
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      if (@growth_record = GrowthRecord.find_by_id(params[:id])) && current_user.student_info.growth_records.include?(@growth_record)
        @creater = User.find_by_id(@growth_record.creater_id) unless @growth_record.creater_id.nil?
        render "my_school/growth_records/show"
      else
        flash[:notice] = "不能查看他人的成长记录或该记录不存在"
        redirect_to garden_my_school_garden_growth_records_path
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      squads = current_user.get_users_ranges[:squads]
      @growth_records = GrowthRecord.where("student_infos.squad_id=? and tp=0",squads.collect(&:id)).joins("LEFT JOIN student_infos on(student_infos.id = growth_records.student_info_id)")
      if (@growth_record = GrowthRecord.find_by_id(params[:id])) && @growth_records.include?(@growth_record)
        @creater = User.find_by_id(@growth_record.creater_id) unless @growth_record.creater_id.nil?
        render "my_school/growth_records/show"
      else
        flash[:notice] = "不能查看他人的成长记录或该记录不存在"
        redirect_to garden_my_school_garden_growth_records_path
      end
    else
      @growth_record = GrowthRecord.find_by_id(params[:id])
      @creater = User.find_by_id(@growth_record.creater_id) unless @growth_record.creater_id.nil?
      render "my_school/growth_records/show"
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      if current_user.student_info.growth_record_ids.include?(params[:id].to_i)
        @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
        render "my_school/growth_records/show"
      else
        flash[:notice] = "只能修改自己的成长记录"
        redirect_to :controller => "/my_school/garden_growth_records", :action => :garden
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      squads = current_user.get_users_ranges[:squads]
      @growth_records = GrowthRecord.where("student_infos.squad_id=? and tp=0",squads.collect(&:id)).joins("LEFT JOIN student_infos on(student_infos.id = growth_records.student_info_id)")
      if (@growth_record = GrowthRecord.find_by_id(params[:id])) && @growth_records.include?(@growth_record)
        render "my_school/growth_records/edit"
      else
        flash[:notice] = "不能编辑他人的成长记录或该记录不存在"
        redirect_to garden_my_school_garden_growth_records_path
      end
    else
      @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      render "my_school/growth_records/edit"
    end
  end

  def update
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    respond_to do |format|
      if @growth_record.update_attributes(params[:growth_record])
        flash[:notice] = '更新宝宝在园成长记录成功.'
        format.html { redirect_to(:action=>:show,:id=>@growth_record.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @growth_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy_multiple
    GrowthRecord.destroy(params[:growth])
    respond_to do |format|
      format.html { redirect_to garden_my_school_garden_growth_records_path }
      format.json { head :no_content }
    end
  end

end
