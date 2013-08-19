#encoding:utf-8
class  MySchool::TopicEntriesController < MySchool::ManageController
  def create
    @topic_entry = TopicEntry.new(params[:topic_entry])

    @topic = Topic.find_by_id(params[:topic_entry][:topic_id])

    if @topic.nil?
      flash[:error] = "非法操作"
      redirect_to my_school_topics_path
      return
    end

    respond_to do |format|
      if @topic_entry.save!
        format.js { render :layout => false }
      else
        format.html { render :action => "new" }
        format.js { render :layout => false }
      end
    end
  end

  def destroy
    @topic_entry = TopicEntry.find(params[:id])
    if current_user.get_users_ranges[:tp] == :all
      @topic_entry.destroy
      flash[:success] = "删除成功"
    elsif current_user.get_users_ranges[:tp] == :teachers
      if @topic_entry.topic.squad.present? && current_user.staff.squad_ids.include?(@topic_entry.topic.squad_id)
        @topic_entry.destroy
        flash[:success] = "删除成功"
      else
        flash[:error] = "没有权限"
      end
    else
      flash[:notice] = "权限不够"
    end
    redirect_to my_school_topic_path(@topic_entry.topic_id)
  end

  def virtual_delete
    @topic_entry = TopicEntry.find_by_id(params[:id])

    @topic = Topic.find_by_id(@topic_entry.topic_id)

    if @topic.nil?
      render :text => "贴子不存在或非法操作", :status => 401
      return
    end

    @level = params[:level] || true

    if current_user.get_users_ranges[:tp] == :all or current_user.id == @topic_entry.creater_id
    elsif current_user.get_users_ranges[:tp] == :teachers
      if @topic_entry.topic.squad.present? && current_user.staff.squad_ids.include?(@topic_entry.topic.squad_id)
        @topic_entry.is_show = 0
        @topic_entry.deleted_at = Time.now.utc
        @topic_entry.save
        respond_to do |format|
          format.js { render :layout => false }
        end
        return
      else
        render :text => "没有权限或贴子回复不存在", :status => 401
        return
      end
    else
      render :text => "没有权限", :status => 401
      return
    end
    @topic_entry.is_show = 0
    @topic_entry.deleted_at = Time.now.utc
    @topic_entry.save
    respond_to do |format|
      format.js { render :layout => false }
    end

  end

  def edit
    @topic_entry = TopicEntry.find_by_id(params[:id])
    if @topic_entry.nil?
      flash[:error] = "回复不存在或没有权限"
      redirect_to :back
      return
    end
    unless @topic_entry.creater_id == current_user.id
      flash[:error] = "没有权限或者贴子回复不存在"
      redirect_to my_school_topic_path(@topic_entry.topic_id)
      return
    end
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
