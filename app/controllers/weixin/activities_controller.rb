#encoding:utf-8
class Weixin::ActivitiesController < Weixin::ManageController

  before_filter :is_student?, :only => [:new, :create, :update, :edit, :destroy]
  def index
    if current_user.get_users_ranges[:tp] == :student
      @activities = @kind.activities.where(:tp => 0, :squad_id => current_user.student_info.squad_id).page(params[:page] || 1).per(10).order("created_at DESC")
    elsif current_user.get_users_ranges[:tp] == :teachers
      @activities = @kind.activities.where("tp = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", 0, current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("created_at DESC")
    else
      @activities = @kind.activities.where(:tp => 0).page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @activity = @kind.activities.where("tp = ? and (squad_id = ? or squad_id is null)", 0, current_user.student_info.squad_id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @activity = @kind.activities.where("tp = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", 0, current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @activity = @kind.activities.find_by_id_and_tp(params[:id], 0)
    end

    if @activity.nil?
      flash[:error] = "没有权限或找不到该活动"
      redirect_to :action => :index
      return
    end

    if params[:activity_entry_tp].presence == "0"
      if @activity.activity_entries.any?
        @activity_entries = @activity.activity_entries.where(:tp => 0).page(params[:page] || 1).per(10)
      end
    elsif params[:activity_entry_tp].presence == "1"
      if @activity.activity_entries.any?
        @activity_entries = @activity.activity_entries.where(:tp => 1).page(params[:page] || 1).per(10)
      end
    else
      if @activity.activity_entries.any?
        @activity_entries = @activity.activity_entries.page(params[:page] || 1).per(10)
      end
    end


    @activity_entry = ActivityEntry.new
    @activity_entry.activity_id = @activity.id
    @activity_entry.creater_id = current_user.id


    if current_user.get_users_ranges[:tp] == :teachers

      if @activity.squad_id.nil?
        if current_user.id == @activity.creater_id
          @activity_entry.tp = 0
        else
          @activity_entry.tp = 1
        end
      else
        @activity_entry.tp = 0
      end

    else
      @activity_entry.tp = 1
    end
  end

  def new
    if current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_squads
    end
    @activity = Activity.new
    @activity.creater_id = current_user.id
    @activity.kindergarten_id = @kind.id
    @activity.tp = 0
    @grades = @kind.grades
  end

  def create
    if params[:activity].present? && params[:activity][:squad_id].present?
      if current_user.get_users_ranges[:tp] == :teachers
        unless current_user.get_users_squads.collect(&:id).include?(params[:activity][:squad_id].to_i)
          flash[:error] = "非法操作"
          redirect_to :action => :index
          return
        end
      end
    end
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
    if current_user.get_users_ranges[:tp] == :teachers
      @activity = @kind.activities.where("tp = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", 0, current_user.staff.id, current_user.id).find_by_id(params[:id].to_i)
    else
      @activity = @kind.activities.find_by_id_and_tp(params[:id], 0)
    end

    if @activity.nil?
      flash[:error] = "活动不存在或没有权限"
      redirect_to :action => :index
    end
  end

  def update
    if params[:activity].present?
      params[:activity][:kindergarten_id] = @kind.id
      params[:activity][:tp] = 0
    end
    if current_user.get_users_ranges[:tp] == :teachers
      @activity = @kind.activities.where("tp = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", 0, current_user.staff.id, current_user.id).find_by_id(params[:id].to_i)
    else
      @activity = @kind.activities.find_by_id_and_tp(params[:id], 0)
    end

    if @activity.update_attributes(params[:activity].except(:squad_id))
      flash[:success] = "修改活动成功"
      redirect_to weixin_activity_path(@activity)
    else
      flash[:error] = "修改活动失败"
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


  protected
    def is_student?
      if current_user.get_users_ranges[:tp] == :student
        flash[:error] = "没有权限"
        redirect_to :action => :index
      end
    end

end


