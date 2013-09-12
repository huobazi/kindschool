#encoding:utf-8
class  MySchool::TopicsController < MySchool::ManageController
  def index
    @topic_categories = @kind.topic_categories.order("sequence DESC")

    unless params[:topic_category_id].blank?
      if topic_category = @kind.topic_categories.find_by_id(params[:topic_category_id])
        if current_user.get_users_ranges[:tp] == :student
          @topics = @kind.topics.where("topic_category_id = ? and approve_status = 0  and (creater_id = ? or squad_id = ? or squad_id is null)", topic_category.id, current_user.id, current_user.student_info.squad_id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC").("created_at DESC")
        elsif current_user.get_users_ranges[:tp] == :teachers
          @topics = @kind.topics.search(params[:topic] || {}).where("topic_category_id = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", topic_category.id, current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        else
          @topics = @kind.topics.where(:topic_category_id => topic_category.id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
        end
        @topic_category_id = params[:topic_category_id]
      else
        flash[:notice] = "没有权限或没有该论坛分类"
        redirect_to my_school_topic_categories_path
      end
      @topic_category_id = params[:topic_category_id]
    else
      if current_user.get_users_ranges[:tp] == :student
        @topics = @kind.topics.where("creater_id = ? or squad_id = ? or squad_id is null", current_user.id, current_user.student_info.squad_id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      elsif current_user.get_users_ranges[:tp] == :teachers
        @topics = @kind.topics.search(params[:topic] || {}).where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1).per(10).order("is_top DESC, created_at DESC")
      else
        @topics = @kind.topics.search(params[:topic] || {}).page(params[:page] || 1).per(10).order("is_top DESC").order("created_at DESC")
      end
    end

    store_search_location

    if request.xhr?
      render "index.js.erb"
    else
      render "index"
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
    @topic_entries = @topic.topic_entries.page(params[:page] || 0).per(10)

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

    if params[:growth_record_id].present? 
      if growth_record = @kind.growth_records.find_by_id(params[:growth_record_id])
        @topic.title = growth_record.full_growth_record_title
        @topic.content = growth_record.full_growth_record_content
      else
        flash[:error] = "没有权限或非法操作"
        redirect_to :back
        return
      end
    end

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
    unless params[:topic][:topic_category_id].present?
      flash[:error] = "必须先选择论坛分类"
      redirect_to :action => :new
      return
    else
      if topic_category = @kind.topic_categories.find_by_id(params[:topic][:topic_category_id])
        @topic.topic_category_id = topic_category.id
      else
        flash[:error] = "找不到该论坛分类或没有权限"
        redirect_to :action => :new
        return
      end
    end
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
    if current_user.get_users_ranges[:tp] == :student
      @topic.squad_id = current_user.student_info.squad_id
    end
    unless params[:appurtenance].blank?
      (params[:appurtenance] || []).each do |p_appurtenance|
       appurtenance=Appurtenance.new(p_appurtenance)
       appurtenance.file_name = p_appurtenance[:avatar].original_filename if p_appurtenance[:avatar]
       if @topic.appurtenances.size < 6
         @topic.appurtenances << appurtenance
       end
      end
    end
    if @topic.save!
      flash[:success] = "添加贴子成功"
      redirect_to my_school_topic_path(@topic)
      return
    else
      flash[:error] = "添加贴子失败"
      render :new
      return
    end
    raise "上传的文件大于6m请重新上传."
    rescue Exception =>ex
      message =[]
      unless @topic.blank?
      (@topic.appurtenances||[]).each do |app|
        unless app.errors.blank?
         str = app.errors.messages[:avatar].join("")
         message << str
        end
      end
    end
      flash[:error] = ex.message
      flash[:error] << message.join(",") unless message.blank?#{}"上传的文件大于6m请重新上传."
      render :new

  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.where(:creater_id => current_user.id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ?", current_user.staff.id, current_user.id).find_by_id(params[:id])
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
      params[:topic][:squad_id] = "NULL"
    end
    if current_user.get_users_ranges[:tp] == :student
      @topic = @kind.topics.find_by_id_and_creater_id(params[:id], current_user.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @topic = @kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ?", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @topic = @kind.topics.find_by_id(params[:id])
    end

    unless params[:appurtenance].blank?
      (params[:appurtenance] || []).each do |p_appurtenance|
       appurtenance=Appurtenance.new(p_appurtenance)
       appurtenance.file_name = p_appurtenance[:avatar].original_filename if p_appurtenance[:avatar]
       if @topic.appurtenances.size < 6
         @topic.appurtenances << appurtenance
       end
      end
    end
    Topic.transaction do
    @topic.save!
    unless current_user.get_users_ranges[:tp] == :all
      if  @topic.update_attributes( params[:topic].except(:is_show, :is_top, :topic_category_id) )
        flash[:success] = "更新贴子成功"
        redirect_to my_school_topic_path(@topic)
      else
        raise "更新贴子失败"
      end
    else
      if @topic.update_attributes( params[:topic].except(:topic_category_id) )
        flash[:success] = "更新贴子成功"
        redirect_to my_school_topic_path(@topic)
      else
        raise  "更新贴子失败"
      end
    end
   end
   rescue Exception =>ex
      message =[]
      unless @topic.blank?
      (@topic.appurtenances||[]).each do |app|
        unless app.errors.blank?
         str = app.errors.messages[:avatar].join("")
         message << str
        end
      end
    end
      flash[:error] = ex.message
      flash[:error] << message.join(",") unless message.blank?#{}"上传的文件大于6m请重新上传."
      render :edit
  end

  def destroy
    unless params[:topic].blank? 
      @topics = @kind.topics.where(:id=>params[:topic])
    else
      @topics = @kind.topics.where(:id=>params[:id])
    end
    if @topics.blank?
      flash[:error] = "请选择贴子"
      redirect_to :action => :index
      return
    end
    @topics.each do |topic|
      topic.destroy
    end
    respond_to do |format|
      flash[:success] = "删除贴子成功"
      format.html { redirect_to my_school_topics_path }
      format.json { head :no_content }
    end
  end

  def my
    @topics = @kind.topics.where(:creater_id => current_user.id).search(params[:topic] || {}).page(params[:page] || 1).per(10).order("created_at DESC")

    render "my_school/topics/index"
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
