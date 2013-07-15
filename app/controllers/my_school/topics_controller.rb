#encoding:utf-8
class  MySchool::TopicsController < MySchool::ManageController
  def index
    @topics = @kind.topics.search(params[:topic] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @topic = Topic.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    @topic_creater = User.find_by_id(@topic.creater_id)
    @topic_entry = TopicEntry.new
    @topic_entry.topic_id = @topic.id
    @topic_entry.creater_id = current_user.id
    @topic_entries = @topic.topic_entries
  end

  def new
    @topic = Topic.new
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
  end

  def create
    @topic = Topic.new(params[:topic])

    if @topic.save!
      flash[:success] = "添加贴子成功"
      redirect_to my_school_topic_path(@topic)
    else
      flash[:error] = "添加贴子失败"
      render :new
    end
  end

  def edit
    @topic = Topic.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def update
    @topic = Topic.find_by_id_and_kindergarten_id(params[:id], @kind.id)

    if @topic.update_attributes(params[:topic])
      flash[:success] = "修改贴子成功"
      redirect_to my_school_topic_path(@topic)
    else
      flash[:error] = "修改贴子失败"
      render :edit
    end
  end

  def destroy
    @topic = Topic.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    @topic.destroy

    respond_to do |format|
      flash[:notice] = '删除贴子成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end
end
