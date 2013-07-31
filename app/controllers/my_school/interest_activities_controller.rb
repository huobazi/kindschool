#encoding:utf-8
class MySchool::InterestActivitiesController < MySchool::ManageController
  # 兴趣活动

  before_filter :is_student?, :only => [:edit, :create, :new, :update, :destroy]

  def index
    if current_user.get_users_ranges[:tp] == :student
      @activities = @kind.activities.search(params[:activity] || {}).where(:tp => 1, :squad_id => current_user.student_info.squad_id).page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @activities = @kind.activities.search(params[:activity] || {}).where(:tp => 1).page(params[:page] || 1).per(10).order("created_at DESC")
    end

    render "my_school/activities/index"
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @activity = @kind.activities.find_by_id_and_tp_and_squad_id(params[:id], 1, current_user.student_info.squad_id)
    else
      @activity = @kind.activities.find_by_id_and_tp(params[:id], 1)
    end
    if @activity.nil?
      flash[:error] = "没有权限"
      redirect_to :action => :index
      return
    end
    @activity_entries = @activity.activity_entries.page(params[:page] || 1).per(10)
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
    @activity.tp = 1

    @grades = @kind.grades

    render "my_school/activities/new"
  end

  def create
    @activity = Activity.new(params[:activity])
    @activity.kindergarten_id = @kind.id
    @activity.creater_id = current_user.id
    @activity.tp = 1

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

  protected
    def is_student?
      if current_user.get_users_ranges[:tp] == :student
        flash[:error] = "没有权限"
        redirect_to :action => :index
      end
    end
end
