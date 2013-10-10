#encoding:utf-8
class MySchool::ActivityEntriesController < MySchool::ManageController

  def create
    if params[:activity_entry]
      params[:activity_entry][:creater_id] = current_user.id
    end
    @activity_entry = ActivityEntry.new(params[:activity_entry])

    @activity = Activity.find_by_id(params[:activity_entry][:activity_id])

    if @activity.nil?
      flash[:error] = "非法操作"
      if params[:mark] == "interest_activities"
        redirect_to my_school_interest_activities_path
      else
        redirect_to my_school_activities_path
      end
      return
    end

    if @activity.tp.presence == 1

      if Time.now.utc > @activity.end_at
        flash[:error] = "该兴趣讨论已经结束,不能回复"
        redirect_to my_school_interest_activity_path(@activity_entry.activity_id)
        return
      end

    end

    if @activity_entry.save!
      flash[:success] = "添加回复成功"
      if params[:mark] == "interest_activities"
        redirect_to my_school_interest_activity_path(@activity_entry.activity_id, :anchor => "activity_entry_#{@activity_entry.id}", :page => @activity_entry.activity.last_page)
        # respond_to do |format|
        #   format.js { render :layout => false }
        # end
      elsif params[:mark] == "activities"
        redirect_to my_school_activity_path(@activity_entry.activity_id, :anchor => "activity_entry_#{@activity_entry.id}", :page => @activity_entry.activity.last_page)
        # respond_to do |format|
        #   format.js { render :layout => false }
        # end
      end
    else
      flash[:error] = "操作失败"
      redirect_to :back
    end
  end

  def edit
    @activity_entry = ActivityEntry.find(params[:id])
    if @activity_entry.nil?
      flash[:error] = "回复不存在或没有权限"
      redirect_to :back
      return
    end
    unless current_user.id = @activity_entry.creater_id
      flash[:error] = "没有权限或回复不存在"
      redirect_to :back
      return
    end
    if params[:page]
      @page = params[:page]
    end
    if params[:flag].present?
      @flag = params[:flag]
    end
  end

  def update
    @activity_entry = ActivityEntry.find(params[:id])

    if params[:flag].presence == "true"
      redirect_to_controller = "activities"
    else
      redirect_to_controller = "interest_activities"
    end

    if @activity_entry.update_attributes(params[:activity])
      flash[:success] = "添加活动回复成功"
      redirect_to :controller => redirect_to_controller, :action => :show, :id => @activity_entry.activity_id, anchor: "activity_entry_#{@activity_entry.id}", page: params[:page]
    else
      flash[:error] = "添加回复失败"
      redirect_to :controller => redirect_to_controller, :action => :show, :id => @activity_entry.activity_id, anchor: "activity_entry_#{@activity_entry.id}", page: params[:page]
    end

  end

  def destroy
    @activity_entry = ActivityEntry.find(params[:id])
    if current_user.tp == 2
      @activity_entry.destroy
      flash[:success] = "删除成功"
      if params[:mark] == "interest_activities"
        redirect_to my_school_interest_activity_path(@activity_entry.activity_id)
      else
        redirect_to my_school_activity_path(@activity_entry.activity_id)
      end
    elsif current_user.id == @activity_entry.creater_id
      @activity_entry.destroy
      flash[:success] = "删除成功"
      if params[:mark] == "interest_activities"
        redirect_to my_school_interest_activity_path(@activity_entry.activity_id)
      else
        redirect_to my_school_activity_path(@activity_entry.activity_id)
      end
    else
      flash[:notice] = "权限不够"
      if params[:mark] == "interest_activities"
        redirect_to my_school_interest_activity_path(@activity_entry.activity_id)
      else
        redirect_to my_school_activity_path(@activity_entry.activity_id)
      end
    end
  end

  def virtual_delete
    @activity_entry = ActivityEntry.find_by_id(params[:id])

    if @activity_entry.nil?
      render :text => "没有权限或活动不存在", :status => 401
      return
    end

    @level = params[:level] || true

    @activity = Activity.find_by_id(@activity_entry.activity_id)

    if current_user.get_users_ranges[:tp] == :all or current_user.id == @activity_entry.creater_id
    elsif current_user.get_users_ranges[:tp] == :teachers
      if @activity_entry.activity.squad.present? && current_user.staff.squad_ids.include?(@activity_entry.activity.squad_id)
        @activity_entry.is_show = 0
        @activity_entry.deleted_at = Time.now.utc
        @activity_entry.save
        respond_to do |format|
          format.js { render :layout => false }
        end
        return
      else
        render :text => "没有权限", status: 401
        return
      end
    else
      render :text => "没有权限", status: 401
      return
    end

    @activity_entry.is_show = 0
    @activity_entry.deleted_at = Time.now.utc
    @activity_entry.save
    respond_to do |format|
      format.js { render :layout => false }
    end

  end
end
