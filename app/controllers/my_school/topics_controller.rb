#encoding:utf-8
class  MySchool::TopicsController < MySchool::ManageController
  def index
    @topic_categories = @kind.topic_categories

    if params[:topic_category_id]
      if topic_category = @kind.topic_categories.find_by_id(params[:topic_category_id])
        if current_user.get_users_ranges[:tp] == :student
          @topics = @kind.topics.where("topic_category_id = ? and (creater_id = ? or squad_id = ? or squad_id is null)", topic_category.id, current_user.id, current_user.student_info.squad_id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC").("created_at DESC")
        elsif current_user.get_users_ranges[:tp] == :teachers
          @topics = @kind.topics.search(params[:topic] || {}).where("topic_category_id = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", topic_category.id, current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        else
          @topics = @kind.topics.where(:topic_category_id => topic_category.id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        end
      else
        flash[:notice] = "没有权限或没有该论坛分类"
        redirect_to my_school_topic_categories_path
      end
    else
      if current_user.get_users_ranges[:tp] == :student
        @topics = @kind.topics.where("creater_id = ? or squad_id = ? or squad_id is null", current_user.id, current_user.student_info.squad_id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      elsif current_user.get_users_ranges[:tp] == :teachers
        @topics = @kind.topics.search(params[:topic] || {}).where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      else
        @topics = @kind.topics.search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC").order("created_at DESC")
      end
    end

  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.where("creater_id = ? or squad_id = ? or squad_id is null", current_user.id, current_user.student_info.squad_id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    if @topic.nil?
      flash[:error] = "没有该贴子或权限不够"
      redirect_to :action => :index
      return
    end

    @topic_entry = TopicEntry.new
    @topic_entry_count = @topic.topic_entries.count
    @topic_entry.topic_id = @topic.id
    @topic_entry.creater_id = current_user.id
    @topic_entries = @topic.topic_entries.page(params[:page] || 1).per(10)

    @topic.show_count += 1
    @topic.save
  end

  def new
    @topic = Topic.new
    if current_user.get_users_ranges[:tp] == :student
      @topic.squad_id = current_user.student_info.squad_id
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
    end
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id

    @grades = @kind.grades
  end

  def create
    if params[:visible].presence == "all"
      params[:topic].delete :squad_id
    else
      if params[:topic].present? && params[:topic][:squad_id].present?
        if current_user.get_users_ranges[:tp] == :teachers
          unless current_user.get_users_ranges[:squads].collect(&:id).include?(params[:topic][:squad_id].to_i)
            flash[:error] = "非法操作"
            redirect_to :action => :index
            return
          end
        end
      end
    end
    unless current_user.get_users_ranges[:tp] == :all
      @topic = Topic.new(params[:topic].except(:is_show, :is_top))
    else
      @topic = Topic.new(params[:topic])
    end
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
    if current_user.get_users_ranges[:tp] == :student
      @topic.squad_id = current_user.student_info.squad_id
    end

    if @topic.save!
      flash[:success] = "添加贴子成功"
      redirect_to my_school_topic_path(@topic)
    else
      flash[:error] = "添加贴子失败"
      render :new
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.where(:creater_id => current_user.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    if @topic.nil?
      flash[:error] = "没有该贴子或没有权限"
      redirect_to :action => :index
    end
  end

  def update
    if params[:topic].present?
      params[:topic][:kindergarten_id] = @kind.id
      if current_user.get_users_ranges[:tp] == :student
        params[:topic][:squad_id] = current_user.student_info.squad_id
      end
    end
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.find_by_id_and_creater_id(params[:id], current_user.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    unless current_user.get_users_ranges[:tp] == :all
      if @topic.update_attributes( params[:topic].except(:is_show, :is_top) )
        flash[:success] = "更新贴子成功"
        redirect_to my_school_topic_path(@topic)
      else
        flash[:error] = "更新贴子失败"
        render :edit
      end
    else
      if @topic.update_attributes( params[:topic] )
        flash[:success] = "更新贴子成功"
        redirect_to my_school_topic_path(@topic)
      else
        flash[:error] = "更新贴子失败"
        render :edit
      end
    end

  end

  def destroy
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to :action => :index
    else
      @topic = Topic.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      @topic.destroy

      respond_to do |format|
        flash[:notice] = '删除贴子成功.'
        format.html { redirect_to(:action=>:index) }
        format.xml  { head :ok }
      end
    end
  end

  def destroy_multiple
    if params[:topic].nil?
      flash[:notice] = "必须选择贴子"
    else
      params[:topic].each do |topic|
        @kind.topics.destroy(topic)
      end
    end

    respond_to do |format|
      format.html {redirect_to my_school_topics_path}
      format.json { header :no_content }
    end
  end

  def my
    @topics = @kind.topics.where(:creater_id => current_user.id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("created_at DESC")

    render "my_school/topics/index"
  end

  def grade_squad_partial
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_squad", :layout => false
  end
end
