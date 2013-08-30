#encoding:utf-8
class Weixin::ActivityEntriesController < Weixin::ManageController
  def create
    if params[:activity_entry]
      params[:activity_entry][:creater_id] = current_user.id
    end
    @activity_entry = ActivityEntry.new(params[:activity_entry])

    if @activity_entry.save
      flash[:success] = "添加回复成功"
      redirect_to weixin_activity_path(@activity_entry.activity_id, :anchor => "activity_entry_#{@activity_entry.id}", :page => @activity_entry.activity.last_page)
    else
      flash[:error] = "操作失败"
      redirect_to :back
    end
  end

end
