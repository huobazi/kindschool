#encoding:utf-8
class MySchool::ActivitiesController < MySchool::ManageController
  # 活动

  def index
    @activities = @kind.activities.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def new
    @activity = Activity.new
    @activity.kindergarten_id = @kind.id
    @activity.creater_id = current_user.id
  end

  def create
    binding.pry
    @activity = Activity.new(params[:activity])

    if @activity.save!
      flash[:success] = "创建活动成功"
      redirect_to my_school_activity_path(@activity)
    else
      flash[:error] = "创建活动未能成功"
      render :new
    end
  end

  def edit
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def update
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    if @activity.update_attributes(params[:activity])
      flash[:success] = "修改活动成功"
      redirect_to my_school_activity_path(@activity)
    else
      flash[:error] = "修改活动未能成功"
      render :edit
    end
  end

  def destroy
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    @activity.destroy

    respond_to do |format|
      flash[:notice] = "删除活动成功"
      format.html { redirect_to(:action => :index) }
      format.xml { head :ok }
    end
  end

end
