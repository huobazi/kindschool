#encoding:utf-8
class Weixin::TopicsController < Weixin::ManageController
  def index
    unless params[:category_id].blank?
      if topic_category = @kind.topic_categories.find_by_id(params[:category_id])
        if current_user.get_users_ranges[:tp] == :student
          @topics = @kind.topics.where("topic_category_id = ? or creater_id = ? or squad_id = ? or squad_id is null", topic_category.id, current_user.id, current_user.student_info.squad_id).page(params[:page] || 1).per(10).order("created_at DESC")
        else
          @topics = @kind.topics.where(:topic_category_id => topic_category.id).page(params[:page] || 1).per(10).order("created_at DESC")
        end
      else
        flash[:error] = "没有权限"
        redirect_to weixin_topics_path
      end
    else
      if current_user.get_users_ranges[:tp] == :student
        @topics = @kind.topics.where(:creater_id => current_user.id).page(params[:page] || 1).per(10).order("created_at DESC")
      else
        @topics = @kind.topics.page(params[:page] || 1).per(10).order("created_at DESC")
      end
    end

  end

  def show
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.where("creater_id = ? or squad_id = ? or squad_id is null", current_user.id, current_user.student_info.squad_id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end
    if @topic.nil?
      flash[:error] = "没有该贴子或权限不够"
      redirect_to :action => :index
      return
    end
    @replies = @topic.topic_entries.page(params[:page] || 1).per(10)
    @topic_entry = TopicEntry.new
    @topic_entry.topic_id = @topic.id
    @topic_entry.creater_id = current_user.id
  end

  def new
    @topic = Topic.new
    if current_user.get_users_ranges[:tp] == :student
      @topic.squad_id = current_user.student_info.squad_id
    end
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
    @grades = @kind.grades
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
    if current_user.get_users_ranges[:tp] == :student
      @topic.squad_id = current_user.student_info.squad_id
    end

    if @topic.save!
      flash[:success] = "贴子创建成功"
      redirect_to weixin_topic_path(@topic)
    else
      flash[:error] = "贴子创建失败"
      render :new
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.where(:creater_id => current_user.id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    if @topic.nil?
      flash[:error] = "没有该贴子或没有权限"
      redirect_to :action => :index
    end
  end

  def update
    if params[:topic]
      params[:topic][:kindergarten_id] = @kind.id
      params[:topic][:creater_id] = current_user.id
    end
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.find_by_id_and_creater_id(params[:id], current_user.id)
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    if @topic.update_attributes(params[:topic])
      flash[:success] = "更新贴子成功"
      redirect_to weixin_topic_path(@topic)
    else
      flash[:error] = "更新贴子失败"
      render :edit
    end
  end

  def my
    @topics = @kind.topics.where(:creater_id => current_user.id).page(params[:page] || 1).per(10).order("created_at DESC")
    render :index
  end

  def grade_squad_partial
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_squad", :layout => false
  end
end
