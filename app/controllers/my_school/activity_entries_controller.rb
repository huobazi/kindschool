#encoding:utf-8
class MySchool::ActivityEntriesController < MySchool::ManageController

  def create
    if params[:activity_entry]
      params[:activity_entry][:creater_id] = current_user.id
    end
    @activity_entry = ActivityEntry.new(params[:activity_entry])

    if @activity_entry.save!
      flash[:success] = "添加回复成功"
      if params[:mark] == "interest_activities"
        redirect_to my_school_interest_activity_path(@activity_entry.activity_id, :anchor => "activity_entry_#{@activity_entry.id}", :page => @activity_entry.activity.last_page)
      elsif params[:mark] == "activities"
        redirect_to my_school_activity_path(@activity_entry.activity_id, :anchor => "activity_entry_#{@activity_entry.id}", :page => @activity_entry.activity.last_page)
      end
    else
      flash[:error] = "操作失败"
      redirect_to :back
    end
  end

  def edit
    @activity_entry = ActivityEntry.find(params[:id])
    if params[:page]
      @page = params[:page]
    end
  end

  def update
    @activity_entry = ActivityEntry.find(params[:id])

    if @activity_entry.update_attributes(params[:activity])
      flash[:success] = "添加活动回复成功"
    else
      flash[:error] = "添加回复失败"
    end
    redirect_to my_school_activity_path(@activity_entry.activity_id, anchor: "activity_entry_#{@activity_entry.id}", page: params[:page])

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
end
