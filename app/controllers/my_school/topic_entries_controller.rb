#encoding:utf-8
class  MySchool::TopicEntriesController < MySchool::ManageController
  def create
    @topic_entry = TopicEntry.new(params[:topic_entry])

    if @topic_entry.save!
      flash[:success] = "添加回复成功"
      redirect_to my_school_topic_path(@topic_entry.topic_id, :anchor => "topic_entry_#{@topic_entry.id}", :page => @topic_entry.topic.last_page)
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

  def edit
    @topic_entry = TopicEntry.find(params[:id])
    if params[:page].present?
      @page = params[:page]
    end
  end

  def update
    @topic_entry = TopicEntry.find(params[:id])

    if @topic_entry.update_attributes(params[:topic_entry])
      flash[:success] = "修改回复成功"
    else
      flash[:sucees] = "修改回复失败"
    end
    redirect_to my_school_topic_path(@topic_entry.topic_id, anchor: "topic_entry_#{@topic_entry.id}", page: params[:page])
  end
end
