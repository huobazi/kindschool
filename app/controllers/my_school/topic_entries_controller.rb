#encoding:utf-8
#论坛帖子的回复
class  MySchool::TopicEntriesController < MySchool::ManageController
  def create
    @topic_entry = TopicEntry.new(params[:topic_entry])

    @topic = Topic.find_by_id(params[:topic_entry][:topic_id])
   
    

    if @topic.nil?
      flash[:error] = "非法操作"
      redirect_to my_school_topics_path
      return
    end

    if @topic_entry.save
      #自己回复的不能进行加积分
     if @topic.creater.id != current_user.id
       if current_user.save_user_credit("topic",1,@topic)
        #反馈意见的要给发帖人加分
        @topic.creater.save_creater_credit("topic",@topic) if @topic.creater

       end
     end

      redirect_to my_school_topic_path(@topic_entry.topic_id, page: @topic.last_page, anchor: "topic_entry_#{@topic_entry.id}")
    else
      render :action => "new"
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
  
  #管理精品回帖
  def goodback
    if @topic_entry = TopicEntry.find(params[:id])
      @topic_entry.set_goodback(params[:tp])
      flash[:success] = "设置成功"
      redirect_to my_school_topic_path(@topic_entry.topic_id)
    else
      flash[:error] = "贴子不存在或非法操作"
      redirect_to my_school_topics_path
    end
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
    @topic_entry = TopicEntry.where(is_show: true).find_by_id(params[:id])
    if @topic_entry.nil?
      flash[:error] = "回复不存在或没有权限"
      redirect_to my_school_topics_path
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
    @topic_entry = TopicEntry.where(is_show: true).find(params[:id])

    if @topic_entry.update_attributes(params[:topic_entry])
      flash[:success] = "修改回复成功"
    else
      flash[:sucees] = "修改回复失败"
    end
    redirect_to my_school_topic_path(@topic_entry.topic_id, anchor: "topic_entry_#{@topic_entry.id}", page: params[:page])
  end
end
