#encoding:utf-8
class  MySchool::TopicEntriesController < MySchool::ManageController
  def create
    @topic_entry = TopicEntry.new(params[:topic_entry])

    if @topic_entry.save!
      flash[:success] = "添加回复成功"
      redirect_to my_school_topic_path(@topic_entry.topic_id)
    else
      flash[:error] = "操作失败"
      redirect_to :back
    end
  end

  def destroy
    @topic_entry = TopicEntry.find(params[:id])
    if current_user.tp == 2
      @topic_entry.destroy
      flash[:success] = "删除成功"
      redirect_to my_school_topic_path(@topic_entry.topic_id)
    elsif current_user.id == @topic_entry.creater_id
      @topic_entry.destroy
      flash[:success] = "删除成功"
      redirect_to my_school_topic_path(@topic_entry.topic_id)
    else
      flash[:notice] = "权限不够"
      redirect_to my_school_topic_path(@topic_entry.topic_id)
    end
  end
end
