#encoding:utf-8
class Weixin::TopicsController < Weixin::ManageController
  include TopicsHelper
  def index
    unless params[:topic_category_id].blank?
      if topic_category = @kind.topic_categories.find_by_id(params[:topic_category_id])
        if current_user.get_users_ranges[:tp] == :student
          @topics = @kind.topics.where("topic_category_id = ? and approve_status = 0  and (creater_id = ? or squad_id = ? or squad_id is null)", topic_category.id, current_user.id, current_user.student_info.squad_id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        elsif current_user.get_users_ranges[:tp] == :teachers
          @topics = @kind.topics.where("topic_category_id = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", topic_category.id, current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        else
          @topics = @kind.topics.where(:topic_category_id => topic_category.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        end
        @topic_category_id = params[:topic_category_id]
      else
        flash[:error] = "没有权限或没有该论坛分类"
        redirect_to weixin_topics_path
      end
    else
      if current_user.get_users_ranges[:tp] == :student
        @topics = @kind.topics.where("creater_id = ? or squad_id = ? or squad_id is null", current_user.id, current_user.student_info.squad_id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      elsif current_user.get_users_ranges[:tp] == :teachers
        @topics = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      else
        @topics = @kind.topics.page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      end
    end

    AccessStatu.update_unread(@kind, "Topic", current_user)

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
    else
      if current_user.id == @topic.creater_id
        @topic.accessed_at = Time.now.utc
        @topic.save
      end
    end
    @replies = @topic.topic_entries.page(params[:page] || 1).per(10)
    @goodbacks = @topic.goodbacks
    
    @topic_entry = TopicEntry.new
    @topic_entry.topic_id = @topic.id
    @topic_entry.creater_id = current_user.id


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
    @topic = Topic.new(params[:topic])
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
    if current_user.get_users_ranges[:tp] == :student
      @topic.squad_id = current_user.student_info.squad_id
    end

    if @topic.save
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
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? ", current_user.staff.id, current_user.id).find_by_id(params[:id])
      @squads = current_user.get_users_ranges[:squads]
    else
      @topic = @kind.topics.find_by_id(params[:id])
      @grades = @kind.grades
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

    if params[:visible].presence == "all"
      params[:topic][:squad_id] = nil
    end
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.find_by_id_and_creater_id(params[:id], current_user.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? ", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    if @topic.update_attributes(params[:topic].except(:topic_category_id))
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
      if params[:default_squad].present?
        @default_squad = params[:default_squad]
      end
    end
    render "grade_squad", :layout => false
  end
end
