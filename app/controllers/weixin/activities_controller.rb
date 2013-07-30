#encoding:utf-8
class Weixin::ActivitiesController < Weixin::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @activities = @kind.activities.where(:tp => 0, :squad_id => current_user.student_info.squad_id).page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @activities = @kind.activities.where(:tp => 0).page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end

  def show
    @activity = @kind.activities.find_by_id(params[:id])
    @replies = @activity.activity_entries.page(params[:page] || 1).per(10)
    @activity_entry = ActivityEntry.new
    @activity_entry.activity_id = @activity.id
    if current_user.id == @activity.creater_id
      @activity_entry.tp = 0
    else
      @activity_entry.tp = 1
    end
    @activity_entry.creater_id = current_user.id
  end

  def new
    @activity = Activity.new
    @activity.creater_id = current_user.id
    @activity.kindergarten_id = @kind.id
    @activity.tp = 0
    @grades = @kind.grades
  end

  def create
    @activity = Activity.new(params[:activity])
    @activity.creater_id = current_user.id
    @activity.kindergarten_id = @kind.id
    @activity.tp = 0

    if @activity.save!
      flash[:success] = "创建活动成功"
      redirect_to weixin_activity_path(@activity)
    else
      flash[:error] = "提交活动失败"
      render :new
    end
  end

  def edit
    @activity = @kind.activities.find_by_id(params[:id])
  end

  def update
    params[:activity][:kindergarten_id] = @kind.id if params[:activity]
    @activity = Activity.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    if @activity.update_attributes(params[:activity])
      flash[:success] = "修改活动成功"
      redirect_to weixin_activity_path(@activity)
    else
      flash[:error] = "修改活动未能成功"
      render :edit
    end
  end

  def grade_squad_partial
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_squad", :layout => false
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


