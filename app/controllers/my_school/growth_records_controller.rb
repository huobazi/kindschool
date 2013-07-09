#encoding:utf-8
class  MySchool::GrowthRecordsController < MySchool::ManageController

  def index
    if current_user.get_users_ranges[:tp] == :all
      @growth_records = @kind.growth_records.page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end

  def new
    @growth_record = GrowthRecord.new
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
  end

  def create
    @growth_record = GrowthRecord.new(params[:growth_record])
    @growth_record.creater_id = current_user.id

    if @growth_record.save!
      flash[:success] = "添加成长记录成功"
      redirect_to :controller => "/my_school/growth_records", :action => :show, :id => @growth_record.id
    else
      flash[:error] = "添加成长记录失败"
      render :new
    end
  end

  def show
    @growth_record = GrowthRecord.find_by_id(params[:id])
    @creater = User.find_by_id(@growth_record.creater_id)
  end

  def edit
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def update
    @growth_record = GrowthRecord.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    respond_to do |format|
      if @growth_record.update_attributes(params[:growth_record])
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@growth_record.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @growth_record.errors, :status => :unprocessable_entity }
      end
    end
  end

end
