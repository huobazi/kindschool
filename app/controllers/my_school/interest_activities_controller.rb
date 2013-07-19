#encoding:utf-8
class MySchool::InterestActivitiesController < MySchool::ManageController
  # 活动

  def index
    @activities = @kind.activities.where(:tp => 1).page(params[:page] || 1).per(10).order("created_at DESC")

    render "my_school/activities/index"
  end

  def show
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    @activity_entries = @activity.activity_entries
    @activity_entry = ActivityEntry.new
    @activity_entry.activity_id = @activity.id
    if current_user.id == @activity.creater_id
      @activity_entry.tp = 0
    else
      @activity_entry.tp = 1
    end
    @activity_entry.creater_id = current_user.id
    render "my_school/activities/show"
  end

  def new
    @activity = Activity.new
    @activity.kindergarten_id = @kind.id
    @activity.creater_id = current_user.id

    render "my_school/activities/new"
  end

  def create
    @activity = Activity.new(params[:activity])

    if @activity.save!
      flash[:success] = "创建兴趣讨论成功"
      redirect_to my_school_interest_activity_path(@activity)
    else
      flash[:error] = "创建兴趣讨论未能成功"
      render :new
    end
  end

  def edit
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    render "my_school/activities/edit"
  end

  def update
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    if @activity.update_attributes(params[:activity])
      flash[:success] = "修改兴趣讨论成功"
      redirect_to my_school_interest_activity_path(@activity)
    else
      flash[:error] = "修改活动未能成功"
      render :edit
    end
  end

  def destroy
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    @activity.destroy

    respond_to do |format|
      flash[:notice] = "删除兴趣讨论成功"
      format.html { redirect_to(:action => :index) }
      format.xml { head :ok }
    end
  end

end
